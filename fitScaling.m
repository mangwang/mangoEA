function fitScaled = fitScaling( fitness, nParents, options )
% Perform fitness scaling before certain selection scheme.
% Need to ensure:
% mean(fitScaled)=sum(fitScaled)/nParents=mean(fitness)=sum(fitness)/n=1
%   Parameters:
%   fitness             - fitness values
%                       [column vector]
%   nParents            - number of parents for next generation
%                       [positive scalar]
%   options             - options
%                       [struct array]

fitness = fitness(:); % fitness values of current population
n = length(fitness); % number of individuals in current population

fitScaled = zeros(size(fitness)); % init scaled fitness values

switch options.FitScalingType
    case 'rank'
        % Reference:
        % http://uk.mathworks.com/help/gads/fitness-scaling.html
        
        % sort fitness in ascending order
        [~, ind] = sort(fitness);
        % calculate scaled fitness
        fitScaled(ind) = 1 ./ ((1:n) .^ 0.5);
        fitScaled = fitScaled * nParents ./ sum(fitScaled);
    case 'top'
        % Reference:
        % Sadjadi, Farzad. "Comparison of fitness scaling functions in
        % genetic algorithms with applications to optical processing."
        % Optical Science and Technology, the SPIE 49th Annual Meeting.
        % International Society for Optics and Photonics, 2004.
        
        % quantity of how many individuals are not 0, default is 0.4
        quantity = options.TopSelectionQuantity;
        % quantity should be a positive integer
        if quantity < 1
            quantity = round(quantity * n); % change the rate to integer
        end
        % sort fitness in ascending order
        [~, ind] = sort(fitness);
        % ensure sum(fitScaled) / nParents = 1
        fitScaled(ind(1:quantity)) = nParents / quantity;
    case 'linear'
        % Reference:
        % Sivanandam, S. N., and S. N. Deepa.
        % Introduction to genetic algorithms.
        % Springer Science & Business Media, 2007.
        % Page 70
        
        % maximumSurvivalRate is the ratio of the fitness of the best
        % individual to the average fitness of the population. Values near 2
        % have been found to work well. Default is 2.
        maximumSurvivalRate = options.LinearSelectionMaximumSurvivalRate;
        
        % minimize the fitness values here
        fitness = -fitness;
        
        maxFit = max(fitness);
        meanFit = mean(fitness);
        minFit = min(fitness);
        
        % take care of the degenerate case where all scores are the same
        if(maxFit == minFit)
            % scaled fitness would be 1*nParents/n
            fitScaled = ones(n, 1) * nParents / n;
            return;
        end
        
        % we must sum to nParents, our desired mean must be
        desiredMean = nParents / n;
        
        % we want to find a scale and an offset so that:
        % 1. scale * max + offset = maximumSurvivalRate * desiredMean
        % 2. scale * mean + offset = desiredMean
        % subtracting 2 from 1 gives scale
        scale = desiredMean * (maximumSurvivalRate - 1) / (maxFit - meanFit);
        offset = desiredMean - scale * meanFit;
        
        % if the above causes the least fitness to go negative,
        % change our goal to have a min of zero & mean of nParents/n
        if(offset + scale * minFit < 0)
            scale = desiredMean / (meanFit - minFit);
            offset = desiredMean - (scale * meanFit);
        end
        
        fitScaled = scale * fitness + offset;
    otherwise
        error('Wrong Fitness Scaling Type!');
end

end

