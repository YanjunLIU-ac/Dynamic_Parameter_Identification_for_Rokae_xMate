%% run_filtering.m
% @brief: offline zero-phase butterworth filtering for: joint angle(q), velocity(vel), acceleration(acc), torque(q)

clear, clc, close all;

% order of filter
n = 5;
% sampling frequency 
ws = 10;
% cut-off frequency
wc = 3;
% number of sampling points
pnt = 200;

%% REMEMBER MANUALLY:
% modify FILE PATH to read sensor data

% read data from file
t_raw = load('.\data\excit\excit_torque_record.txt');
m_raw = load('.\data\excit\excit_motor_record.txt');
q_raw = load('.\data\excit\excit_ang_record.txt');
qd_raw = load('.\data\excit\excit_vel_record.txt');
qdd_raw = load('.\data\excit\excit_acc_record.txt');

% downsampling
[q_ds, qd_ds, qdd_ds, t_ds] = downsampling(q_raw, qd_raw, qdd_raw, t_raw, pnt);
[~, ~, ~, m_ds] = downsampling(q_raw, qd_raw, qdd_raw, m_raw, pnt);

%% REMEMBER MANUALLY:
% modify FILE PATH to save figures in ang_filter\vel_filter\acc_filter\trq_filter.m

% angle filter
q_filt = ang_filter(n, ws, wc, q_ds, '.\figs\excit\ang\');
% velocity filter (by derivate of q)
% qd_filtered = vel_filter(n, ws, wc, q_filtered, 'derivate');
% velocity filter (by sensor)
qd_filt = vel_filter(n, ws, wc, qd_ds, 'sensor', '.\figs\excit\vel\');

% acceleration filter (by second order derivate of q)
qdd_filt = acc_filter(n, ws, wc, qd_filt, 'derivate', '.\figs\excit\acc\');
% acceleration filter (by sensor)
% qdd_filtered = acc_filter(n, ws, wc, qdd_ds, 'sensor');

% torque filter (motor or joint torque) 
t_filt = trq_filter(n, ws, wc, t_ds, '.\figs\excit\trq\');

%% REMEMBER MANUALLY:
% modify FILE PATH to save mat data

clear n pnts;
save('.\data\excit\excit_filtering.mat')
save('..\identify\data\excit_filtering.mat');
save('..\dynamics\data\mat\excit_filtering.mat');