function plotConverTrend(FEsEachGen, bestFit, func_name, saveFigPath, figName)
% Plot the convergence trend.
%   Parameters:
%   FEsEachGen          - The number of fitness evaluations of each generation
%                       [row vector]
%   bestFit             - The best fitness values, can be bestFitSoFar or bestFitEachGen
%                       [row vector]
%   func_name           - Function names
%                       [cell array of strings]
%   func_num            - The number of optimization functions
%                       [positive scalar]
%   run_num             - The number of run times
%                       [positive scalar]
%   figName             - The name of the saved figure
%                       [string]


figure('Visible', 'off');
semilogy(FEsEachGen, bestFit, 'b');
xlabel('FEs');
ylabel('$log(f(x)-f(x^*))$', 'interpreter', 'latex');
title(func_name);
grid on;
print([saveFigPath, filesep, figName], '-depsc');
close;

end

