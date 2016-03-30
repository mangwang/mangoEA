function saveEachGen( gens, savePath, x, fit )
% Save genotype/x and phenotype/fit into mat file
%   Parameters:
%   gens                - The number of generations
%                       [positive scalar]
%   savePath            - Path to save
%                       [string]
%   x                   - genotype
%                       [Matrix]
%   fit                 - phenotype
%                       [column vector]


if ~ismatrix(x)
    error('x should be matrix!');
end
if ~isvector(fit)
    error('fit should be a column vector!');
end

if ~isdir(savePath)
    mkdir(savePath);
end
save([savePath, filesep, num2str(gens), '.mat'], 'x', 'fit');

end

