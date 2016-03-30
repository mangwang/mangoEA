function bestFitness( bestFitEachGen, bestFitSoFar, FEsEachGen, ...
    func_name, func_num, run_num, options )
% Save best_fit_so_far and best_fit_each_gen to a .mat file, then plot the
% convergence curve of best_fit_so_far and best_fit_each_gen.
%   Parameters:
%   bestFitEachGen      - The best fitness values of each generation
%                       [row vector]
%   bestFitSoFar        - The best fitness values so fat
%                       [row vector]
%   FEsEachGen          - The number of fitness evaluations of each generation
%                       [row vector]
%   func_name           - Function names
%                       [cell array of strings]
%   func_num            - The number of optimization functions
%                       [positive scalar]
%   run_num             - The number of run times
%                       [positive scalar]

% save best_fit_so_far and best_fit_each_gen to a .mat file
saveBestPath = ['result', filesep, 'conver_trend', filesep, 'dim_', num2str(options.Dim),...
    filesep, func_name{func_num}, filesep, options.AlgoName, filesep, ...
    'run_', num2str(run_num)];
if ~isdir(saveBestPath)
    mkdir(saveBestPath);
end
save([saveBestPath, filesep, 'bestFitSoFar.mat'], 'bestFitSoFar', 'FEsEachGen');
save([saveBestPath, filesep, 'bestFitEachGen.mat'], 'bestFitEachGen', 'FEsEachGen');

% plot convergence curve of best_fit_so_far and best_fit_each_gen
plotConverTrend(FEsEachGen, bestFitSoFar, func_name{func_num}, saveBestPath, 'bestFitSoFar');
plotConverTrend(FEsEachGen, bestFitEachGen, func_name{func_num}, saveBestPath, 'bestFitEachGen');

end

