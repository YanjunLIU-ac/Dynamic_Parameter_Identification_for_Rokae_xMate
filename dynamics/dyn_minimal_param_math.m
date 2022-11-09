%% dyn_minimal_param_math.m
% @brief: QR decomposition to figure out minimal parameter set (direct arithmetic expression)
% @param[out] W_min: regression matrix for minimal parameter set 
% @param[out] min_param_ind: minimal parameter set
% @param[out] pnum_min: volume of minimal parameter set
% @param[out] R1: matrix consisting of independent columns
% @param[out] R2: matrix consisting of dependent columns
% @note: Unit:mm(Nmm) is used throughout the project.
function [W_min, min_param_ind, pnum_min, R1, R2] = dyn_minimal_param_math()

addpath('.\utils')
%% PARAMETER
% DH and load parameters
fe1 = 0; fe2 = 0; fe3 = 0; ne1 = 0; ne2 = 0; ne3 = 0;
d1 = 341.5; d3 = 394.0; d5 = 366; d7 = 250.3; g = 9802; % in mm
% number of dynamic parameters
% m, mc1, mc2, mc3, Ioxx, Ioyy, Iozz, Ioxy, Ioxz, Ioyz, Ia, fv, fc
pnum_sum = evalin('base', 'pnum_sum');
% regression matrix for standard parameter set (syms 7 x 91)
W = evalin('base', 'W');

%% INSTANTIATION
% q = zeros(1, 7);
% qd = zeros(1, 7);
% qdd = zeros(1, 7);
min_param_ind = zeros(1, pnum_sum);		% the index of minimal parameters 
WW = zeros(pnum_sum * 7, pnum_sum);
for i = 1:pnum_sum
    q = unifrnd(-pi, pi, 1, 7);	
    qd = unifrnd(-5*pi, 5*pi, 1, 7);
    qdd = unifrnd(-10*pi, 10*pi, 1, 7);
    
	row1 = 1+7*(i-1); row2 = 7+7*(i-1);
    WW(row1:row2, :) = regressor(q, qd, qdd);

    disp(['<INFO> Param No.', num2str(i), ' SUBSTITUTED!!']);
end

%% LOOK FOR NAN AND INF
if (sum(sum(isnan(WW))) > 0)
    ind_nan = find(isnan(WW));    % linear index of nan
    sub_nan = zeros(length(ind_nan), 2);    % array index of nan
    joint_nan = zeros(1, length(ind_nan));  % among 7 joints
    iter_nan = zeros(1, length(ind_nan));   % among 200 trajectory setpoints
    for n = 1:length(ind_nan)
        [sub_nan(n, 1), sub_nan(n, 2)] = ind2sub(size(WW), ind_nan(n));
        joint_nan(n) = mod(sub_nan(n, 1), 7);
        iter_nan(n) = fix(sub_nan(n, 1)/7) + 1;
    end
    disp(sub_nan)
	disp(joint_nan)
	pause
else
    disp('No NaN in matrix.');
end

if (sum(sum(isinf(WW))) > 0)
    ind_inf = find(isinf(WW));    % linear index if inf
    sub_inf = zeros(length(ind_inf), 2);    % array index of inf
    joint_inf = zeros(length(ind_inf), 1);  % among 7 joints
    iter_inf = zeros(length(ind_inf), 1);   % among 200 trajectory setpoints
    for n = 1:length(ind_inf)
        [sub_inf(n, 1), sub_inf(n, 2)] = ind2sub(size(WW), ind_inf(n));
        joint_inf(n) = mod(sub_inf(n, 1), 7);
        iter_inf(n) = fix(sub_inf(n, 1)/7) + 1;
    end
    disp(sub_inf)
	disp(joint_inf)
	pause
else
    disp('No Inf in matrix.');
end

%% QR DECOMPOSITION
% WW=Q*R, WW:(7*pnum_sum, pnum_sum), Q:(7*pnum_sum, 7*pnum_sum), R:(7*pnum_sum, pnum_sum)
[Q, R] = qr(WW);
pnum_min = 0;	% number of independent parameter
for i = 1:pnum_sum
   if (abs(R(i, i)) < 10^(-5))
       min_param_ind(i) = 0;
   else
       min_param_ind(i) = 1;
       pnum_min = pnum_min + 1;
   end
end
disp('<INFO> QR DECOMPOSITION complete!!');

W_min = sym(zeros(7, pnum_min));	% regression matrix (minimal set)
R1 = zeros(pnum_min, pnum_min);
R2 = zeros(pnum_min, pnum_sum - pnum_min);
cind = 1; cdep = 1;	% count the number of independent and dependent columns
for i = 1:pnum_sum
   if (min_param_ind(i) == 1)
      W_min(:, cind) = W(:, i);		% compose independent columns in W to form matrix WB
      R1(1:pnum_min, cind) = R(1:pnum_min, i);	% compose independent columns in R to form matrix RB
      cind = cind + 1;
   else
      R2(1:pnum_min, cdep) = R(1:pnum_min, i);
      cdep = cdep + 1;
   end
end
disp('<INFO> WB (W_min) matrix OBTAINED!!');

%% SAVE DATA
fid = fopen('.\data\txt\dyn_minimal_param_math.txt', 'w');
for i = 1:7
    for j = 1:pnum_min
        fprintf(fid, 'w_min%d%d=%s;\r', i, j, char(W_min(i, j)));
    end
end
fclose(fid);

%% RETURN VARIABLE TO BASE WORKSPACE
assignin('base', 'W_min', W_min);
assignin('base', 'min_param_ind', min_param_ind);
assignin('base', 'pnum_min', pnum_min);
assignin('base', 'R1', R1);
assignin('base', 'R2', R2);

rmpath('.\utils')




