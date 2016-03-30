function [ x, fit, saveGenPath ] = initFstGen( optionalArgs, options, func_name, ...
    func_num, run_num )
% Initialise the first generation including genotype and phenotype..
%   Parameters:
%   optionalArgs        - The optional arguments, feasible fields include
%                         all fields in options and 'InitPopulation',
%                         'InitFitness', 'fst_num'
%                       [struct array | See definitions of EA_setOptions()]
%   Fields of optionalArgs:
%   InitPopulation      - The initial population used in seeding the GA
%                         algorithm
%                       [ Matrix | [] ]
%   InitFitness         - The initial fitness values used to determine fitness
%                       [ column vector | [] ]
%   fst_num             - The number of first generation
%                       [positive scalar]
%   options             - The options get from EA_setOptions() function
%                       [struct array | See definitions of EA_setOptions()]
%   fst_num             - The number of first generation, it is also a flag
%                         to check whether to generate just one offspring
%                       [positive scalar]
%   func_num            - The number of optimization functions
%                       [positive scalar]
%   run_num             - The number of run times
%                       [positive scalar]


if isfield(optionalArgs, 'InitPopulation') && isfield(optionalArgs, 'InitFitness')
    x = optionalArgs.InitPopulation;
    fit = optionalArgs.InitFitness;
    if isfield(optionalArgs, 'fst_num')
        % just generate one offspring if provided the field 'fst_num'
        saveGenPath = ['result', filesep, 'raw_data', filesep, 'dim_', num2str(options.Dim),...
            filesep, func_name{func_num}, filesep, options.AlgoName, filesep, 'fst_',...
            num2str(optionalArgs.fst_num), filesep, 'run_', num2str(run_num)];
    else
        saveGenPath = ['result', filesep, 'raw_data', filesep, 'dim_', num2str(options.Dim),...
        filesep, func_name{func_num}, filesep, options.AlgoName, filesep, ...
        'run_', num2str(run_num)];
    end
else
    lb = options.PopInitRange(1);
    ub = options.PopInitRange(2);
    x = lb + (ub - lb) * rand(options.PopulationSize, options.Dim);
    fit = benchmark_func(x, func_num);
    saveGenPath = ['result', filesep, 'raw_data', filesep, 'dim_', num2str(options.Dim),...
        filesep, func_name{func_num}, filesep, options.AlgoName, filesep, ...
        'run_', num2str(run_num)];
end

end

