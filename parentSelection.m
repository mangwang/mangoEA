function parents = parentSelection( fitness, nParents, options )
% Perform the parent selection for the next crossover and mutation operation.
% The returned parents is the indices of chosen individuals.
%   Parameters:
%   fitness             - fitness values
%                       [column vector]
%   nParents            - number of parents for next generation
%                       [positive scalar]
%   options             - options
%                       [struct array]


fitness = fitness(:); % fitness values of current population
parents = zeros(1, nParents); % indices of parents

switch options.ParentSelectionType
    case 'FPS'
        % Perform Fitness Proportionate Selection (FPS) using roulette
        % wheel selection.
        
        % Reference:
        % Agoston E. Eiben and J. E. Smith. 2015.
        % Introduction to Evolutionary Computing, 2nd Edition. SpringerVerlag.
        % Page 83, Fig. 5.1
        
        % first calculate the cumulative probability distribution
        cumProb = cumsum(fitness) / sum(fitness);
        
        % run roulette wheel selection
        current_member = 1; % index of chosen individual
        while current_member <= nParents    
            r = rand; % pick a random value r uniformly from (0,1)
            i = 1;
            while cumProb(i) < r
                i = i + 1;
            end
            parents(current_member) = i;
            current_member = current_member + 1;
        end
    case 'SUS'
        % Perform Stochastic Universal Sampling (SUS).
        
        % Reference:
        % Agoston E. Eiben and J. E. Smith. 2015.
        % Introduction to Evolutionary Computing, 2nd Edition. SpringerVerlag.
        % Page 84, Fig. 5.2
        
        % first calculate the cumulative probability distribution
        cumProb = cumsum(fitness) / sum(fitness);
        
        % run stochastic universal sampling
        step = 1 / nParents;
        r = rand * step; % pick a random value r uniformly from (0, 1/nParents)
        
        current_member = 1; % index of chosen individual
        i = 1; % index of current population to be chosen
        while current_member <= nParents
            while cumProb(i) >= r
                parents(current_member) = i; % selection
                r = r + step;
                current_member = current_member + 1;
            end
            i = i + 1;
        end
    case 'tournament'
        % Perform Tournament Selection.
        % Tournament selection is an selection that it does not require any
        % global knowledge of the population, nor a quantifiable measure
        % of quality.
        
        % Reference:
        % Agoston E. Eiben and J. E. Smith. 2015.
        % Introduction to Evolutionary Computing, 2nd Edition. SpringerVerlag.
        % Page 84, Fig. 5.3
        
        % the tournament size, default is 4
        tournamentSize = options.TournamentSelectionTournamentSize;
        
        current_member = 1; % index of chosen individual
        while current_member <= nParents
            % pick k individuals from the population at random without replacement,
            % note that the generated candidates are indices
            candidates = randperm(length(fitness), tournamentSize);
            % compare these candidates and select the best of them
            [~, best_ind] = min(fitness(candidates));
            parents(current_member) = best_ind;
            current_member = current_member + 1;
        end
    case 'uniform'
        % Perform Uniform Random Selection.
        % Evolution Strategies (ES) are usually implemented with uniform random
        % selection.
        
        parents = rand(1, nParents);
        % indices are on the interval [1,n], where n = length(fitness)
        parents = ceil(parents * length(fitness));
    otherwise
        error('Wrong Parent Selection Type!');
end

end

