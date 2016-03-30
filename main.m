% Execute the whole process
clear;clc;close all;

% set parameters
func_names = {'Sphere', 'Schwefel-102', 'Rotated-Elliptic', 'Rosenbrock', ...
    'Rotated-Ackley', 'Rastrigin', 'Rotated-Rastrign', 'Rotated-Weierstrass'};
algo_names = {'GA'};

% dims = [2, 10, 30, 50];
dims = 2;
nFunctions = length(func_names);
nAlgos = length(algo_names);
runs_normal = 4;

% Run EAs on different test functions, the generated generations are
% regarded as sampled local landscapes in the function space
options = setOptions(); % init options
for dim = dims
    for func_num = 1:nFunctions
        % init first generation for each function to ensure every EA has
        % the same first generation
        [lb, ub] = get_lb_ub(func_num);
        % if want to change PopulationSize, set in here, not in optionalArgs
        x = lb + (ub - lb) * rand(options.PopulationSize, dim);
        fit = benchmark_func(x, func_num);
        
        for algo_num = 1:nAlgos
            algo_name = algo_names{algo_num};
            % set optinalArgs struct
            optionalArgs.AlgoName = algo_names{algo_num};
            optionalArgs.Dim = dim;
            optionalArgs.PopInitRange = [lb, ub];
            optionalArgs.InitPopulation = x;
            optionalArgs.InitFitness = fit;
            % run an EA
            feval(algo_name, runs_normal, func_names, func_num, optionalArgs);
        end
    end
end
delete(gcp);

% Calculate evolvability
% for dim = dims
%     for func_num = 1:n_functions
%         for algo = 1:n_algos
%             for run = 1:runs_normal
%                 cal_escape_prob(func_name, func_num, n_pop, dim, algo_name{algo}, run);
%             end
%         end
%     end
% end
% for dim = 2
%     for func_num = 1
%         for algo = 1:n_algos
%             for run_fst = 1:runs_normal
%                 cal_escape_prob(func_name, func_num, algo_name{algo}, n_pop, dim, run_fst);
%             end
%         end
%     end
% end

