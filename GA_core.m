function GA_core( run_num, func_name, func_num, optionalArgs )
% Perform the core part of Genetic Algorithm.
%   Parameters:
%   run_num             - The number of run times
%                       [positive scalar]
%   func_name           - Function names
%                       [cell array of strings]
%   func_num            - The number of optimization functions
%                       [positive scalar]
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
%   fst_num             - The number of first generation, it is also a flag
%                         to check whether to generate just one offspring
%                       [positive scalar]


% Init options
options = setOptions();

% set options using optionalArgs
names = fieldnames(optionalArgs); % cell array of string
for i = 1:length(names)
    if isfield(options, names{i})
        options = setOptions(options, names{i}, optionalArgs.(names{i}));
    end
    if strcmp(names{i}, 'PopulationSize')
        options = setOptions(options, 'EliteCount', 0.05*optionalArgs.PopulationSize);
    end
    if strcmp(names{i}, 'Dim')
        options = setOptions(options, 'MaxFEs', 10000*optionalArgs.Dim);
    end
end

% Init several local variables
FEs = 0; % Total fitness evaluations
gens = 0; % Total number of generations
bestFitEachGen = []; % The best fitness values of each generation
bestFitSoFar = []; % The best fitness values so fat
FEsEachGen = []; % The number of fitness evaluations of each generation

% Init the first generation
[x, fit, saveGenPath] = initFstGen(optionalArgs, options, func_name, func_num, run_num);

% Update local variables
FEs = FEs + options.PopulationSize;
gens = gens + 1;
best_fit = min(fit);
bestFitEachGen(gens) = best_fit;
bestFitSoFar(gens) = best_fit;
FEsEachGen(gens) = FEs;

% Save this generation to file
saveEachGen(gens, saveGenPath, x, fit);

% Perform the optimization process
if isfield(optionalArgs, 'fst_num')
    % just generate one offspring if provided the field 'fst_num'
    FEs = options.MaxFEs;
end
while FEs <= options.MaxFEs
    % calculate how many different kinds of offspring will be generated
    nEliteKids = options.EliteCount; % number of elite kids
    % number of crossover kids
    nXoverKids = round(options.CrossoverFraction * (options.PopulationSize - nEliteKids));
    % calculate how many parents need be selected to perform crossover
    % crossover: two parents generate two kids
    % need to make sure nParentsXover is even
    if ~rem(nXoverKids, 2)
        nParentsXover = nXoverKids;
    else
        nParentsXover = nXoverKids - 1;
    end
    nXoverKids = nParentsXover; % update the new number of crossover kids
    % number of mutation kids
    nMutationKids = options.PopulationSize - nEliteKids - nXoverKids;
    
    % select parents for crossover
    % fitness scaling, default is 'rank'
    fitScaled = fitScaling(fit, options.PopulationSize, options);
    % parent selection, default is 'SUS'
    % the returned parents are indices of selected parents
    parents = parentSelection(fitScaled, nXoverKids, options);
    % randomly shuffle the selected parents' indices
    parents = parents(randperm(length(parents)));
    
    % the crossover kids
    % perform crossover: two parents generate two kids
    xoverKids = crossover(x, parents, options);
    
    % mutation on xoverKids: one parent generate one kid
    mutationIndices = randperm(nMutationKids);
    mutationKids = mutation(xoverKids(mutationIndices, :), options);
    
    % the elite kids
    [~, ind] = sort(fit);
    elitsKids = x(ind(1:nEliteKids), :);
    
    % survival selection using the generational replacement
    % form the new x
    x = [elitsKids; xoverKids; mutationKids];
    % evaluate the new population
    fit = benchmark_func(x, func_num);
    
    % Update local variables
    FEs = FEs + options.PopulationSize;
    gens = gens + 1;
    best_fit = min(fit);
    bestFitEachGen(gens) = best_fit;
    % judge best fitness value so far
    if best_fit < bestFitSoFar(gens-1)
        bestFitSoFar(gens) = best_fit;
    else
        bestFitSoFar(gens) = bestFitSoFar(gens-1);
    end
    FEsEachGen(gens) = FEs;
    
    % Save this generation to file
    saveEachGen(gens, saveGenPath, x, fit);
    
    % reached the global optimum
    residual = abs(bestFitSoFar(gens)) - 0; % global optimal = 0
    if residual <= options.TolFun
        break;
    end
    
end

% if generate multiple generations
if ~isfield(optionalArgs, 'fst_num')
    bestFitness(bestFitEachGen, bestFitSoFar, FEsEachGen, ...
        func_name, func_num, run_num, options);
end

end

