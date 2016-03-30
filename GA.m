function GA( runs, func_name, func_num, optionalArgs )
% Framework for Genetic Algorithm (GA).
% General scheme of EAs:
% 1. Decide a genetic representation of a candidate solution to the
%    problem, including define the genotype and the mapping/function from 
%    genotype to phenotype;
% 2. Initialise the parameters.
% 3. Initialise the first generation with a population of candidate
%    solutions;
% 4. Evaluate each candidate in the first generation;
% 5. Parent selection (fitness scaling may be necessary before certain selection);
% 6. Recombine pairs of parents;
% 7. Mutate the resulting offspring;
% 8. Evaluate new candidates;
% 9. Survival selection;
% 10. Goto 5, and Loop until termination condition is satisfied.
% 11. Goto 1. and Loop if want to run several times.

%   Parameters:
%   runs                - Total run times
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


parfor run_num = 1:runs
    GA_core(run_num, func_name, func_num, optionalArgs);
end

end

