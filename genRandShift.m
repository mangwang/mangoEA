function  rand_shift = genRandShift( func_num, dim, reinitialization )
% Generate 1 * dim vector of random values in [reg_lb, reg_ub].
%   Parameters:
%   func_num            - Number of the test function
%                       [positive scalar]
%   dim                 - Dimension
%                       [positive scalar]
%   reinitialization    - A boolean value to judge if need reinitialization the
%                         former rand shift
%                       [bool]


[reg_lb, reg_ub] = get_lb_ub(func_num);

if reinitialization == true && exist( ['rand_shift_', num2str(reg_ub), '.mat'], 'file')
    delete(['rand_shift_', num2str(reg_ub), '.mat']);
end
if ~exist( ['rand_shift_', num2str(reg_ub), '.mat'], 'file')
    rand_shift = reg_lb + (reg_ub - reg_lb) * rand(1, dim);
    save(['rand_shift_', num2str(reg_ub), '.mat'], 'rand_shift');
else
    load_struct = load(['rand_shift_', num2str(reg_ub), '.mat']);
    rand_shift = load_struct.rand_shift;
end

end

