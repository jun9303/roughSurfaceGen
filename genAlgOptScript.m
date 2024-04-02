warning('off','all')

%%%%%%%%%%%%%% FIX THESE PARAMETERS BEFORE RUNNING THE OPTIMIZER %%%%%%%%%%%%%%
L_x = 25; % in mm
L_z = 25; % in mm
goal = [.4 .534 4.74 1.25 5.78 11.5]; % [R_a, R_q, R_d, R_sk, R_ku, lam] in mm
seed = 1; % random seed integer
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

n_processors = 6; % use your system's maximum (or allowed) number of processors
try
    parpool('Processes', n_processors, 'IdleTimeout', Inf)
catch
    ...
end

% input parameter bounds
lb = [2 .1 .1 .1 .2]; % [n, W_k, W_l, gamma, beta]
ub = [2 10 10  2  5];

nvars = length(lb);
popSize = 200;

% randomly generated initial population.
initPopMat = zeros(popSize, nvars);
for i = 1:nvars
    initPopMat(:,i) = randr(lb(i),ub(i),popSize,1);
end

% genetic algorithm options
options = optimoptions('ga','ConstraintTolerance',1e-6, ...
                            'FunctionTolerance',1e-6, ...
                            'MaxGenerations',5000, ...
                            'MaxStallGenerations',500, ...
                            'FitnessLimit', 1e-2, ...
                            'PopulationSize',popSize, ...
                            'InitialPopulationMatrix',initPopMat, ...
                            'MutationFcn',{@mutationgaussian, 1, .5}, ...
                            'UseParallel',true, 'UseVectorized',false, ...
                            'Display','iter','OutputFcn',@genAlgOutputFcn);

% ga run
[best,fval] = ga(@(x) genAlgRoughFitEval(x,L_x,L_z,goal,seed), nvars, ...
                 [], [], [], [], lb, ub, [], options);

% shut down parallel pool
delete(gcp("nocreate"));

function x = randr(l,u,sz1,sz2)
    rng("shuffle");
    x = (u-l).*rand(sz1,sz2) + l;
end