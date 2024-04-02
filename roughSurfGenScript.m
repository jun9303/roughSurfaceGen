% n: Roughness element shape factor (2: making elements quadratic)    
% R_l: Scale parameter of the Weibull distribution (for R_p) (in mm)  
% R_k: Shape parameter of the Weibull distribution (for R_p) (in mm)  
% gamm: gamma*K_p = D_p (D_p is a diameter of an roughness element)            
% beta: adjustment factor to calculate the total # of elements        
% 
% L_x: Surface streamwise(x) length (in mm) 
% L_z: Surface spanwise(z) length (in mm)                             

%%%% adjust these parameters %%%%
n = 2;
R_k = 1.53932855828047;
R_l = 0.821535347167132; 
gamm = 1.14341179097394; 
beta = 0.348252811720820;
L_x = 25; L_z = 25; % in mm
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%% changing this alters overall randomness %%%%
random_seed = 743;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

rough_surface = roughSurfClass(n, R_l, R_k, gamm, beta, L_x, L_z, seed=random_seed);
f = figure(1);
f.Position = [100 100 540 300];
[s, ax] = rough_surface.show();
rough_results = rough_surface.evaluate();
title(sprintf('$R_a$: %5.3f mm, $R_q$: %5.3f mm, $R_d$: %4.2f mm, $R_{sk}$: %4.2f, $R_{ku}$: %4.2f, $\\Lambda$: %4.1f', ...
      rough_results(1),rough_results(2),rough_results(3),rough_results(4),rough_results(5),rough_results(6)), 'interpreter','latex')