%% least_square_estimation.m
% @brief: estimate parameter using Least Square Method (LSM) in arithmetic expression manner

%% PARAMETER
load('.\data\filt.mat');
% filtered data
q_filt = evalin('base', 'q_filt');
qd_filt = evalin('base', 'qd_filt');
qdd_filt = evalin('base', 'qdd_filt');
t_filt = evalin('base', 't_filt');
% DH and load parameters
fe1 = 0; fe2 = 0; fe3 = 0; ne1 = 0; ne2 = 0; ne3 = 0;
d1 = 0.3415; d3 = 0.394; d5 = 0.366; d7 = 0.2503; g = 9.802; % in m
% minimal param set
pnum_min = evalin('base', 'pnum_min');

n = length(q_filt);		% number of sampling points
ww = zeros(n * 7, pnum_min);
TT = zeros(n * 7, 1);
for k = 1:n
	q = q_filt(k, :);
	qd = qd_filt(k, :);
	qdd = qdd_filt(k, :);

	row1 = 1+(k-1)*7;
	row2 = 7+(k-1)*7;
	ww(row1:row2, :) = min_regression_mat(q, qd, qdd);		
	TT(row1:row2, 1) = 1e3 * t_filt(k, :)';
end

%% MAP TO MINMAL PARAMETER SET
% ww * P = TT  ->  P =  inv(ww.T*ww)*ww.T*TT
% ww:(n*7, pnum_min), TT:(n*7, 1), P:(pnum_min, 1)
P = ((ww' * ww)^(-1)) * ww' * TT;
assignin('base', 'P_min', P);	% assign variable in workspace

%% SAVE TO FILE
% fid = fopen('.\data\P_min.txt', 'w');
% fprintf(fid, 'P_min = [');
% for j = 1:pnum_min
%     fprintf(fid, '%s;', P(j));
% end
% fprintf(fid, '];');