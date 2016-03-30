function xoverKids = crossover( x, parents, options )
% Perform crossover in all selected parents.
%   Parameters:
%   x                   - genotype of all population
%                       [Matrix]
%   parents             - indices of all selected parents
%   options             - options
%                       [struct array]


nParents = length(parents);
Dim = size(x, 2);
twoParents = zeros(2, Dim);
xoverKids = zeros(length(parents), Dim);

for i = 1:2:nParents
    ind_1 = parents(i);
    ind_2 = parents(i+1);
    twoParents(1, :) = x(ind_1, :);
    twoParents(2, :) = x(ind_2, :);
    xoverChilden = crossoverTwoParents(twoParents, options);
    xoverKids(i:i+1, :) = xoverChilden;
end

end

