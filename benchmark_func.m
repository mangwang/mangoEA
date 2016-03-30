function fit = benchmark_func(X, func_num)
% Evaluate fitness values of related benchmark functions.
%   Parameters:
%   X                   - This population.
%                       [Matrix]
%   func_num            - The number of optimization functions
%                       [positive scalar]


switch func_num
    case 1
        % Shifted Sphere Function
        % search space: [-100, 100], global fmin: 0
        fit = sphere(X, func_num);
    case 2
        % Shifted Schwefel's Problem 1.2
        % search space: [-100, 100], global fmin: 0
        fit = schwefel_102(X, func_num);
    case 3
        % Shifted Rotated High Conditioned Elliptic Function
        % search space: [-100, 100], global fmin: 0
        fit = high_cond_rot_elliptic(X, func_num);
    case 4
        % Shifted Rosenbrock's Function
        % search space: [-100, 100], global fmin 0
        fit = rosenbrock(X, func_num);
    case 5
        % Shifted Rotated Ackley's Function
        % search space: [-32, 32], global fmin 0
        fit = rot_ackley(X, func_num);
    case 6
        % Shifted Rastrigin's Function
        % search space: [-5, 5], global fmin 0
        fit = rastrigin(X, func_num);
    case 7
        % Shifted Rotated Rastrign's Function
        % search space: [-5, 5], global fmin 0
        fit = rot_rastrigin(X, func_num);
    case 8
        % Shifted Rotated Weierstrass Function
        % search space: [-0.5, 0.5], global fmin 0
        fit = rot_weierstrass(X, func_num);
end
end

function fit = sphere(X, func_num)
% Shifted Sphere Function
% search space: [-100, 100], global fmin 0
persistent rand_shift_init;
[n_pop, dim] = size(X);
% generate 1*100 random shifted vector in [reg_lb, reg_ub]
if isempty(rand_shift_init)
    rand_shift_init = genRandShift(func_num, 100, 0);
end
rand_shift = rand_shift_init(1:dim); % cut dim dimensions
% randomly shift the population X
X = X - repmat(rand_shift, n_pop, 1);
% calculate fitness values
fit = sum(X.^2, 2);
end

function fit =  schwefel_102(X, func_num)
% Shifted Schwefel's Problem 1.2
% search space: [-100, 100], global fmin 0
persistent rand_shift_init;
[n_pop, dim] = size(X);
% generate 1*100 random shifted vector in [reg_lb, reg_ub]
if isempty(rand_shift_init)
    rand_shift_init = genRandShift(func_num, 100, 0);
end
rand_shift = rand_shift_init(1:dim); % cut dim dimensions
% randomly shift the population X
X = X - repmat(rand_shift, n_pop, 1);
% calculate fitness values
fit = 0;
for i = 1:dim
    fit = fit + sum(X(:,1:i), 2).^2;
end
end

function fit = high_cond_rot_elliptic(X, func_num)
% Shifted Rotated High Conditioned Elliptic Function
% search space: [-100, 100], global fmin 0
persistent rand_shift_init;
[n_pop, dim] = size(X);
% generate 1*100 random shifted vector in [reg_lb, reg_ub]
if isempty(rand_shift_init)
    rand_shift_init = genRandShift(func_num, 100, 0);
end
rand_shift = rand_shift_init(1:dim); % cut dim dimensions
% randomly shift the population X
X = X - repmat(rand_shift, n_pop, 1);
% rotated X
if dim == 2
    load('auxiliary/elliptic_M_D2.mat');
elseif dim == 10
    load('auxiliary/elliptic_M_D10.mat');
elseif dim == 30
    load('auxiliary/elliptic_M_D30.mat');
elseif dim == 50
    load('auxiliary/elliptic_M_D50.mat');
else
    A = normrnd(0, 1, dim, dim);
    [M, ~] = cGram_Schmidt(A);
end
X = X * M;
% calculate fitness values
a = 1e+6;
fit = 0;
for i = 1:dim
    fit = fit + a.^((i-1)/(dim-1)).*X(:,i).^2;
end
end

function fit = rosenbrock(X, func_num)
% Shifted Rosenbrock's Function
% search space: [-100, 100], global fmin 0
persistent rand_shift_init;
[n_pop, dim] = size(X);
% generate 1*100 random shifted vector in [reg_lb, reg_ub]
if isempty(rand_shift_init)
    rand_shift_init = genRandShift(func_num, 100, 0);
end
rand_shift = rand_shift_init(1:dim); % cut dim dimensions
% randomly shift the population X
X = X - repmat(rand_shift, n_pop, 1) + 1;
% calculate fitness values
fit = sum(100.*(X(:,1:dim-1).^2 - X(:,2:dim)).^2 + (X(:,1:dim-1) - 1).^2, 2);
end

function fit = rot_ackley(X, func_num)
% Shifted Rotated Ackley's Function
% search space: [-32, 32], global fmin 0
persistent rand_shift_init;
[n_pop, dim] = size(X);
% generate 1*100 random shifted vector in [reg_lb, reg_ub]
if isempty(rand_shift_init)
    rand_shift_init = genRandShift(func_num, 100, 0);
end
rand_shift = rand_shift_init(1:dim); % cut dim dimensions
% randomly shift the population X
X = X - repmat(rand_shift, n_pop, 1) + 1;
% rotated X
if dim == 2
    load('auxiliary/ackley_M_D2.mat');
elseif dim == 10
    load('auxiliary/ackley_M_D10.mat');
elseif dim == 30
    load('auxiliary/ackley_M_D30.mat');
elseif dim == 50
    load('auxiliary/ackley_M_D50.mat');
else
    c = 100;
    M = rot_matrix(dim, c);
end
X = X * M;
% calculate fitness values
fit = sum(X.^2, 2);
fit = 20 - 20*exp(-0.2*sqrt(fit/dim))-exp(sum(cos(2.*pi.*X),2)./dim) + exp(1);
end

function fit = rastrigin(X, func_num)
% Shifted Rastrigin's Function
% search space: [-5, 5], global fmin 0
persistent rand_shift_init;
[n_pop, dim] = size(X);
% generate 1*100 random shifted vector in [reg_lb, reg_ub]
if isempty(rand_shift_init)
    rand_shift_init = genRandShift(func_num, 100, 0);
end
rand_shift = rand_shift_init(1:dim); % cut dim dimensions
% randomly shift the population X
X = X - repmat(rand_shift, n_pop, 1) + 1;
% calculate fitness values
fit = sum(X.^2 - 10.*cos(2.*pi.*X) + 10, 2);
end

function fit = rot_rastrigin(X, func_num)
% Shifted Rotated Rastrigin's Function
% search space: [-5, 5], global fmin 0
persistent rand_shift_init;
[n_pop, dim] = size(X);
% generate 1*100 random shifted vector in [reg_lb, reg_ub]
if isempty(rand_shift_init)
    rand_shift_init = genRandShift(func_num, 100, 0);
end
rand_shift = rand_shift_init(1:dim); % cut dim dimensions
% randomly shift the population X
X = X - repmat(rand_shift, n_pop, 1) + 1;
% rotated X
if dim == 2
    load('auxiliary/rastrigin_M_D2.mat');
elseif dim == 10
    load('auxiliary/rastrigin_M_D10.mat');
elseif dim == 30
    load('auxiliary/rastrigin_M_D30.mat');
elseif dim == 50
    load('auxiliary/rastrigin_M_D50.mat');
else
    c = 2;
    M = rot_matrix(dim, c);
end
X = X * M;
fit = sum(X.^2 - 10.*cos(2.*pi.*X) + 10, 2);
end


function fit = rot_weierstrass(X, func_num)
% Shifted Rotated Weierstrass Function
% search space: [-0.5, 0.5], global fmin 0
persistent rand_shift_init;
[n_pop, dim] = size(X);
% generate 1*100 random shifted vector in [reg_lb, reg_ub]
if isempty(rand_shift_init)
    rand_shift_init = genRandShift(func_num, 100, 0);
end
rand_shift = rand_shift_init(1:dim); % cut dim dimensions
% randomly shift the population X
X = X - repmat(rand_shift, n_pop, 1) + 1;
% rotated X
if dim == 2
    load('auxiliary/weierstrass_M_D2.mat');
elseif dim == 10
    load('auxiliary/weierstrass_M_D10.mat');
elseif dim == 30
    load('auxiliary/weierstrass_M_D30.mat');
elseif dim == 50
    load('auxiliary/weierstrass_M_D50.mat');
else
    c = 5;
    M = rot_matrix(dim, c);
end
X = X * M;
X = X + 0.5;
a = 0.5; % 0<a<1
b = 3;
kmax = 20;
c1(1:kmax+1) = a.^(0:kmax);
c2(1:kmax+1) = 2*pi*b.^(0:kmax);
c = -w(0.5, c1, c2);
fit = 0;
for i = 1:dim
    fit = fit +w(X(:,i)', c1, c2);
end
fit = fit + repmat(c*dim, n_pop, 1);
end

function y = w(x, c1, c2)
y = zeros(length(x), 1);
for k = 1:length(x)
    y(k) = sum(c1 .* cos(c2.*x(:,k)));
end
end

function [q, r] = cGram_Schmidt(A)
% Computes the QR factorization of A via classical Gram Schmid
[~, m] = size(A);
q = A;
r = zeros(1);
for j = 1:m
    for i = 1:j-1
        r(i, j) = q(:, j)' * q(:, i);
    end
    for i = 1:j-1
        q(:, j) = q(:, j) -  r(i, j) * q(:, i);
    end
    t = norm(q(:,j), 2);
    q(:, j) = q(:, j) / t;
    r(j, j) = t;
end
end

function M = rot_matrix(D, c)
% Generate M to rotate X
A = normrnd(0, 1, D, D);
P = cGram_Schmidt(A);
A = normrnd(0, 1, D, D);
Q = cGram_Schmidt(A);
u = rand(1, D);
D = c.^((u-min(u))./(max(u)-min(u)));
D = diag(D);
M = P*D*Q;
end