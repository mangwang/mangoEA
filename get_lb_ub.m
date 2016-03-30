function [ lb, ub ] = get_lb_ub( func_num )
% Get lower bound and upper bound of each test function.
%   Parameters:
%   func_num            - Number of the test function
%                       [positive scalar]


% get lb and ub of the whole search space
if func_num >= 1 && func_num <= 4
    % Shifted Sphere Function
    % Shifted Schwefel's Problem 1.2
    % Shifted Rotated High Conditioned Elliptic Function
    % Shifted Rosenbrock's Function
    lb = -100;
    ub = 100;
elseif func_num == 5
    % Shifted Rotated Ackley's Function
    lb = -32;
    ub = 32;
elseif func_num == 6 || func_num == 7
    % Shifted Rastrigin's Function
    % Shifted Rotated Rastrign's Function
    lb = -5;
    ub = 5;
elseif func_num == 8
    % Shifted Rotated Weierstrass Function
    lb = -0.5;
    ub = 0.5;
end

end

