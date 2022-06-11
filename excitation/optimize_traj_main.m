%% optimize_traj_main.m
% @brief: solve constrained non-linear optimization problem for 
%         excitation trajectory generation
%         (Refer to `Study on Parameter Identification for Rokae XB4`)
% @dependency: optimize_traj_vis.m (for visualization)
%              optimize_traj_object_func.m (trajectory function)
%              optimize_traj_constraints_mat.m (optimization constraints)

addpath('.\utils');
%% PARAMETERS
% sampling period
traj_Ts = 0.1;
% trajectory fundamental frequency
traj_f = 0.05;
% trajectory fundamental frequency in radian
traj_wf = traj_f * 2 * pi;
% number of sampling points
traj_n = 1 / traj_Ts / traj_f;
% order of trajectory generation 
traj_order = 5;
% number of revolute joints
dof = 7;
% minimal param set
pnum_min = 70;

%% CONSTRAINTS
[A, b, Aeq, beq] = optimize_traj_constraints_mat(traj_wf, traj_Ts, traj_n);

%% SOLVE OPTIMIZATION PROBLEM
% load("opt_x0.mat");
opt_x0 = zeros(77, 1) + 0.1;		% initial value
object = @optimize_traj_object_fun_math;
nonlcon = @optimize_traj_nonl_constraints;
options = optimoptions(@fmincon, 'MaxIterations', 10000, 'MaxFunctionEvaluations', 10000);
% [opt_x, opt_fval] = fmincon(object, opt_x0, A, b, Aeq, beq, [], [], nonlcon, options);
[opt_x, opt_fval] = fmincon(object, opt_x0, A, b, Aeq, beq);

%% VISUALIZATION
% optimize_traj_vis();

rmpath('.\utils');
