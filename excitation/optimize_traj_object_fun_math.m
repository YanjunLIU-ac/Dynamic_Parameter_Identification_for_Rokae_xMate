function f = optimize_traj_object_fun_math(x) 
% @brief: figure out object function for trajectory optimization
%         (using arithmetic expression)
% @param[in] x: hyper-parameter matrix (q_{0}, alpha and beta)
% @param[out] f: object function (conditon number of ww)

addpath('.\utils')
%% PARAMETERS
% trajectory parameters
traj_wf = evalin('base', 'traj_wf');
traj_Ts = evalin('base', 'traj_Ts');
traj_n = evalin('base', 'traj_n'); 
traj_order = evalin('base', 'traj_order');
dof = evalin('base', 'dof');
% minimal param set
pnum_min = evalin('base', 'pnum_min');
disp('<INFO> Parameters LOADED!!')

%% INSTANTIATION
ww = zeros(traj_n * dof, pnum_min);
for k = 1:traj_n
    row1 = 1+(k-1)*7; 
    row2 = 7+(k-1)*7;

    % generate trajectory
	[q, qd, qdd] = traj_func(x, dof, (k-1)*traj_Ts, traj_wf, traj_order);
	ww(row1:row2,:) = min_regressor(q, qd, qdd);
    
    % disp(['<INFO> Setpoint ', num2str(k),  ' on trajectory SUBSTITUTED!! #NaN total: ', num2str(sum(sum(isnan(ww))))])
end

%% LOOK FOR NAN AND INF
if (sum(sum(isnan(ww))) > 0)
    ind_nan = find(isnan(ww));    % linear index of nan
    sub_nan = zeros(length(ind_nan), 2);    % array index of nan
    joint_nan = zeros(1, length(ind_nan));  % among 7 joints
    iter_nan = zeros(1, length(ind_nan));   % among all trajectory setpoints
    for n = 1:length(ind_nan)
        [sub_nan(n, 1), sub_nan(n, 2)] = ind2sub(size(ww), ind_nan(n));
        joint_nan(n) = mod(sub_nan(n, 1), 7);
        iter_nan(n) = fix(sub_nan(n, 1)/7) + 1;
    end
    disp(sub_nan)
else
    disp('No NaN in matrix.');
end

if (sum(sum(isinf(ww))) > 0)
    ind_inf = find(isinf(ww));    % linear index if inf
    sub_inf = zeros(length(ind_inf), 2);    % array index of inf
    joint_inf = zeros(length(ind_inf), 1);  % among 7 joints
    iter_inf = zeros(length(ind_inf), 1);   % among all trajectory setpoints
    for n = 1:length(ind_inf)
        [sub_inf(n, 1), sub_inf(n, 2)] = ind2sub(size(ww), ind_inf(n));
        joint_inf(n) = mod(sub_inf(n, 1), 7);
        iter_inf(n) = fix(sub_inf(n, 1)/7) + 1;
    end
    disp(sub_inf)
else
    disp('No Inf in matrix.');
end

%% CHECK FOR EQUALITY CONSTRAINTS
[opt_q0, opt_qd0, opt_qdd0] = traj_func(x, dof, 0, traj_wf, traj_order);
[opt_qn, opt_qdn, opt_qddn] = traj_func(x, dof, traj_n*traj_Ts, traj_wf, traj_order);
q_init = [0; pi/6; 0; pi/3; 0; pi/2; 0];    % initial configuration
disp(['initial error, q: ', num2str(sum(opt_q0 - q_init)), ', qd: ', num2str(sum(opt_qd0)), ', qd: ', num2str(sum(opt_qdd0))]);
disp(['terminal error, q: ', num2str(sum(opt_qn - q_init)), ', qd: ', num2str(sum(opt_qdn)), ', qd: ', num2str(sum(opt_qddn))]);

%% CONDITION NUMBER
f = cond(ww);
disp(['CondNum: ', num2str(f)]);

rmpath('.\utils')
end