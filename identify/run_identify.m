%% PART I: IMPLEMENT LEAST SQUARE ESTIMATION
% clear, clc, close all;
% load('data\min_regressor.mat');
% load('data\excit_filtering.mat');
% % trajectory sampling period
% traj_Ts = 0.01;
% % number of minimal parameter set
% pnum_min = 70;
% 
% %% REMEMBER MANUALLY:
% % 1. modify inf/nan substitution in `least_square_estimation.m`
% % 2. copy `..\excitation\utils\min_regressor.m` to `.\utils\min_regressor.m`
% % 3. check Système International d'Unités of {DH, G} in 
% % - `miniparam_inverse_dynamics.m`
% % - `least_square_estimation_syms.m` or `least_square_estimation_math.m` 
% % - `.\utils\min_regressor.m`
% 
% least_square_estimation_syms;
% % least_square_estimation_math;
% clear ans;
% save('.\data\least_square.mat');
% save('..\dynamics\data\mat\least_square.mat');

%% PART II: VERIFY WITH MINIMAL PARAMETER SET
% clear; load('data\least_square.mat');
% verify_identified_parameter;