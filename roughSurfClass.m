classdef roughSurfClass
    properties
        n double {mustBeInRange(n,1,5)} = 2
        Lx double {mustBeNumeric} = 10.
        Lz double {mustBeNumeric} = 10.
        Nr int32 {mustBeInteger} = 0        % total # of roughness elements
        Kp (1,:) double {mustBeNumeric}     % heights of the roughness elements
        Dp (1,:) double {mustBeNumeric}     % diameters of the roughness elements
        Xp (1,:) double {mustBeNumeric}     % x-positions of the roughness elements
        Zp (1,:) double {mustBeNumeric}     % z-positions of the roughness elements
    end
    
    methods
        function obj = roughSurfClass(n, W_l, W_k, gamm, beta, L_x, L_z, options)
            arguments
                n double {mustBeInRange(n,1.5,2.5)}
                W_l double {mustBeInRange(W_l,0.1,10)}
                W_k double {mustBeInRange(W_k,0.1,10)}
                gamm double {mustBeInRange(gamm,0.1,2)}
                beta double {mustBeInRange(beta,0.1,10)}
                L_x double
                L_z  double
                options.seed int32 {mustBeInteger} = 0
            end
            % Params
            % n: Roughness element shape factor (2: making elements quadratic)     
            % W_l: Scale parameter of the Weibull distribution (for R_p) (in mm)   
            % W_k: Shape parameter of the Weibull distribution (for R_p) (in mm)   
            % gamm: gamma*K_p = D_p (diameter of an roughness element)             
            % beta: adjustment factor to calculate the total # of elements         
            
            % L_x: Surface streamwise(x) length (in mm)                            
            % L_z: Surface spanwise(z) length (in mm)                              
            R_p_mean = W_l * gamma(1 + 1 / W_k);
            N_r = min([cast( L_x*L_z / (pi/4*(gamm*beta*R_p_mean)^2), 'int32' ) 1e4]); % 1e4 to avoid too many elements
            obj.n = n; obj.Lx = L_x; obj.Lz = L_z;
            obj.Nr = N_r;
            
            wbl = makedist('Weibull','a',W_l,'b',W_k); % Weibull distribution
            t = truncate(wbl, 0, R_p_mean*inf); % change inf (default) to a finite multiplier to use the truncated dist

            rng(options.seed, "twister"); % Mersen Twister (see Matsumoto & Nishimura 1998; DOI:10.1145/272991.272995)
            for i = 1:N_r
                obj.Kp(i) = random(t,1);
                obj.Xp(i) = unifrnd(0, L_x);
                obj.Zp(i) = unifrnd(0, L_z);
            end
            obj.Dp = obj.Kp*gamm;
        end
        
        function [s, ax] = show(obj) % this class-dependent method plots the rough surface object in a 3DSurf form. 
            x = 0:0.1:obj.Lx; % resolution of 0.1 [mm] for smoother rendering
            z = 0:0.1:obj.Lz; % resolution of 0.1 [mm] for smoother rendering
            Y = zeros(length(x), length(z));
            for nn = 1:obj.Nr
                Xind = find(x>=obj.Xp(nn)-obj.Dp(nn) & x<=obj.Xp(nn)+obj.Dp(nn));
                Zind = find(z>=obj.Zp(nn)-obj.Dp(nn) & z<=obj.Zp(nn)+obj.Dp(nn));
                for i = min(Xind):max(Xind)
                    for k = min(Zind):max(Zind)
                        height = max((1 - (sqrt((x(i)-obj.Xp(nn))^2+(z(k)-obj.Zp(nn))^2)/(obj.Dp(nn)/2))^obj.n), 0);
                        Y(i,k) = max(Y(i,k), obj.Kp(nn)*height);
                    end
                end
            end
            [X,Z] = meshgrid(x,z);
            ax = axes();
            s = surf(ax, X,Z,Y, LineStyle='none', FaceColor='interp');
            view([-45 70]); zlim([0 5]);
            ax.XLabel.Interpreter = 'latex';
            ax.YLabel.Interpreter = 'latex';
            ax.ZLabel.Interpreter = 'latex';
            ax.XLabel.String='$x$ (mm)'; ax.YLabel.String='$z$ (mm)'; ax.ZLabel.String='$y$ (mm)'; ax.Colormap=sky;
            ylim([0 25]); xlim([0 25]); clim([0 5]);
        end

        function res = evaluate(obj) % this class-dependent method evaluates the rough surface's roughness properties.
            res = zeros(6,1);
            x = 0:0.5:obj.Lx; % resolution of 0.5 [mm]
            z = 0:0.5:obj.Lz; % resolution of 0.5 [mm]
            Y = zeros(length(x), length(z));
            for nn = 1:obj.Nr
                Xind = find(x>=obj.Xp(nn)-obj.Dp(nn) & x<=obj.Xp(nn)+obj.Dp(nn));
                Zind = find(z>=obj.Zp(nn)-obj.Dp(nn) & z<=obj.Zp(nn)+obj.Dp(nn));
                for i = min(Xind):max(Xind)
                    for k = min(Zind):max(Zind)
                        height = max((1 - (sqrt((x(i)-obj.Xp(nn))^2+(z(k)-obj.Zp(nn))^2)/(obj.Dp(nn)/2))^obj.n), 0);
                        Y(i,k) = max(Y(i,k), obj.Kp(nn)*height);
                    end
                end
            end
            melt_down_Y = mean(Y,"all");
            eta = Y - melt_down_Y;

            res(1) = sum(abs(eta),"all")/numel(eta);            % Ra (average roughness)
            res(2) = sqrt(sum(eta.^2,"all")/numel(eta));        % Rq (RMS roughness)
            res(3) = max(eta,[],"all") - min(eta,[],"all");     % Rd (roughness depth)
            res(4) = 1/res(2)^3*(sum(eta.^3,"all")/numel(eta)); % Rsk (skewness)
            res(5) = 1/res(2)^4*(sum(eta.^4,"all")/numel(eta)); % Rku (kurtosis)

            res(6) = 0; % Lambda or van Rij roughness (see van Rij et al. 2002; DOI:10.1115/1.1486222)
            [X,Z] = meshgrid(x,z);
            
	        T = delaunay(X,Z);
            TO = triangulation(T, X(:), Z(:), Y(:));

            A = obj.Lx * obj.Lz; Af = 0; Aw = 0;
            for i = 1:size(TO.ConnectivityList, 1)
                a = TO.Points(TO.ConnectivityList(i,:),:);
                p0 = a(1,:);
                p1 = a(2,:);
                p2 = a(3,:);
                normal = cross(p0-p1, p0-p2);
                normal = normal / norm(normal);
                if (normal(3) < 0) % assume that all outward normal vectors are towards +z
                    normal = - normal; 
                end
                if (normal(1) >= 0) % consider only windward triangular elements
                    continue; 
                end
                Aw = Aw + 0.5 * norm(cross(p0-p1, p0-p2));
                p0(1) = 0; p1(1) = 0; p2(1) = 0;
                Af = Af + 0.5 * norm(cross(p0-p1, p0-p2));
            end
            res(6) = (A/Af)*(Af/Aw)^(-1.6);
        end
    end
end
