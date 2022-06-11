%% run_optimize.m
% @brief: optimize excitation trajectory

clear, clc, close all;

%% REMEMBER MANUALLY:
% modify Système International d'Unités of {DH, G} in `utils\min_regressor.m` and 'optimize_object_fun_syms.m'
% copy scripts in `dyn_minimal_param_math.txt` to `utils\min_regressor.m`

optimize_traj_main; 

% save to mat
clear ans;
save('.\data\opt_x.mat', 'opt_x');

% save to txt
addpath('.\utils\')
mat2txt('.\data\opt_x.txt', opt_x);
rmpath('.\utils\')