function xoverChilden = crossoverTwoParents(parents, options)
% Perform crossover between two parents.
% The returned parents is the indicies of chosen individuals.
%   Parameters:
%   parents             - genotype of selected two parents
%                       [Matrix, Dim*2 dimension]
%   options             - options
%                       [struct array]


parent_1 = parents(1, :);
parent_2 = parents(2, :);
L = length(parent_1);

xoverChilden = zeros(size(parents));

if(strcmpi(options.PopulationType, 'doubleVector'))
    switch options.CrossoverType
        case 'simpleArithmetic'
            % Reference:
            % Agoston E. Eiben and J. E. Smith. 2015.
            % Introduction to Evolutionary Computing, 2nd Edition. SpringerVerlag.
            % Page 65.
            
            % pick a random recombination point k, k is in [1, L-1]
            % the whole range is in [0, L]
            k = max(1, floor(rand * length(parent_1)));
            
            % perform simple arithmetic recombination
            alpha = rand;
            child_1 = parent_1;
            child_2 = parent_2;
            % note that index of Matlab starts from 1
            child_1(k+1:L) = alpha * parent_2(k+1:L) + (1-alpha) * parent_1(k+1:L);
            % exchange parent_1 and parent_2 to generate child_2
            child_2(k+1:L) = alpha * parent_1(k+1:L) + (1-alpha) * parent_2(k+1:L);
            
            xoverChilden(1,:) = child_1;
            xoverChilden(2,:) = child_2;
        case 'singleArithmetic'
            % Reference:
            % Agoston E. Eiben and J. E. Smith. 2015.
            % Introduction to Evolutionary Computing, 2nd Edition. SpringerVerlag.
            % Page 66.
            
            % pick a random recombination point k, k is in [1, L-1]
            % the whole range is in [0, L]
            k = max(1, floor(rand * length(parent_1)));
            
            % perform single arithmetic recombination
            alpha = rand;
            child_1 = parent_1;
            child_2 = parent_2;
            child_1(k) = alpha * parent_2(k) + (1-alpha) * parent_1(k);
            % exchange parent_1 and parent_2 to generate child_2
            child_2(k) = alpha * parent_1(k) + (1-alpha) * parent_2(k);
            
            xoverChilden(1,:) = child_1;
            xoverChilden(2,:) = child_2;
        case 'wholeArithmetic'
            % Reference:
            % Agoston E. Eiben and J. E. Smith. 2015.
            % Introduction to Evolutionary Computing, 2nd Edition. SpringerVerlag.
            % Page 66.
            
            alpha = rand;
            xoverChilden(1, :) = alpha * parent_1 + (1-alpha) * parent_2;
            xoverChilden(2, :) = alpha * parent_2 + (1-alpha) * parent_1;
        case 'uniformSimpleArithmetic'
            % Reference:
            % Agoston E. Eiben and J. E. Smith. 2015.
            % Introduction to Evolutionary Computing, 2nd Edition. SpringerVerlag.
            % Page 65.
            
            % uniform means alpha = 0.5 for all parents
            
            % pick a random recombination point k, k is in [1, L-1]
            % the whole range is in [0, L]
            k = max(1, floor(rand * length(parent_1)));
            
            % perform simple arithmetic recombination
            alpha = 0.5;
            child_1 = parent_1;
            child_2 = parent_2;
            % note that index of Matlab starts from 1
            child_1(k+1:L) = alpha * parent_2(k+1:L) + (1-alpha) * parent_1(k+1:L);
            % exchange parent_1 and parent_2 to generate child_2
            child_2(k+1:L) = alpha * parent_1(k+1:L) + (1-alpha) * parent_2(k+1:L);
            
            xoverChilden(1,:) = child_1;
            xoverChilden(2,:) = child_2;
        case 'uniformSingleArithmetic'
            % Reference:
            % Agoston E. Eiben and J. E. Smith. 2015.
            % Introduction to Evolutionary Computing, 2nd Edition. SpringerVerlag.
            % Page 65.
            
            % uniform means alpha = 0.5 for all parents
            
            % pick a random recombination point k, k is in [1, L-1]
            % the whole range is in [0, L]
            k = max(1, floor(rand * length(parent_1)));
            
            % perform single arithmetic recombination
            alpha = 0.5;
            child_1 = parent_1;
            child_2 = parent_2;
            child_1(k) = alpha * parent_2(k) + (1-alpha) * parent_1(k);
            % exchange parent_1 and parent_2 to generate child_2
            child_2(k) = alpha * parent_1(k) + (1-alpha) * parent_2(k);
            
            xoverChilden(1,:) = child_1;
            xoverChilden(2,:) = child_2;
        case 'uniformWholeArithmetic'
            % Reference:
            % Agoston E. Eiben and J. E. Smith. 2015.
            % Introduction to Evolutionary Computing, 2nd Edition. SpringerVerlag.
            % Page 65.
            
            % uniform means alpha = 0.5 for all parents
            alpha = 0.5;
            xoverChilden(1, :) = alpha * parent_1 + (1-alpha) * parent_2;
            % exchange parent_1 and parent_2 to generate child_2
            xoverChilden(2, :) = alpha * parent_2 + (1-alpha) * parent_1;
        case 'intermediate'
            % Reference:
            % http://www.geatbx.com/docu/algindex-03.html#P570_30836
            
            % generate L uniformly distributed random numbers in (-0.25, 1.25)
            alpha = 1.5 * rand(1, L) - 0.25;
            xoverChilden(1, :) = alpha .* parent_1 + (1-alpha) .* parent_2;
            % exchange parent_1 and parent_2 to generate child_2
            xoverChilden(2, :) = alpha .* parent_2 + (1-alpha) .* parent_1;
        case 'discrete'
            % Reference:
            % Agoston E. Eiben and J. E. Smith. 2015.
            % Introduction to Evolutionary Computing, 2nd Edition. SpringerVerlag.
            % Page 65.
            
            % generate L uniformly distributed random numbers in (0, 1)
            r = rand(1, L);
            if(sum(rand > 0.5) == 0 || sum(rand > 0.5) == L)
                ind = ceil(rand * L);
                r(ind) = 1 - r(ind);
            end
            % z_i = x_i or z_i = y_i with equal probablity
            child_1 = parent_1;
            child_2 = parent_2;
            indices = r > 0.5;
            child_1(indices) = parent_2(indices);
            % exchange parent_1 and parent_2 to generate child_2
            child_2(indices) = parent_1(indices);
            
            xoverChilden(1,:) = child_1;
            xoverChilden(2,:) = child_2;
        case 'SBX'
            % Reference:
            % Ortiz-Boyer, Domingo, C¨¦sar Herv¨¢s-Mart¨ªnez, and Nicol¨¢s Garc¨ªa-Pedrajas.
            % "Improving crossover operator for real-coded genetic algorithms using virtual parents."
            % Journal of Heuristics 13.3 (2007): 265-314.
            
            % SBX stands for Simulated Binary Crossover.
            
            % default eta is 5
            eta = options.CrossoverSBX_eta;
            
            B_k = zeros(1, length(L));
            u = rand(1, length(L));
            B_k(u <= 0.5) = (2 .* u(u <= 0.5)) .^ (1 / (eta + 1));
            B_k(u > 0.5) = (1 ./ (2 .* (1 - u(u > 0.5)))) .^ (1 / (eta + 1));
            
            child_1 = 0.5 .* (((1 + B_k) .* parent_1) + (1 - B_k) .* parent_2);
            child_2 = 0.5 .* (((1 - B_k) .* parent_1) + (1 + B_k) .* parent_2);
            
            xoverChilden(1,:) = child_1;
            xoverChilden(1,:) = child_2;
        otherwise
            error('Wrong Crossover Type!');
    end   
elseif(strcmpi(options.PopulationType, 'bitstring'))
    error('Need to be finished!');
else
    error('Wrong Population Type!');
end

end