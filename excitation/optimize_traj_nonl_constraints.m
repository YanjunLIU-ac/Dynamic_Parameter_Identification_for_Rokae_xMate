function [c, ceq] = optimize_traj_nonl_constraints(x)
% @brief: figure out inequality and equality non-linear constraints
% @param[in]: hyper-parameter matrix (q_{0}, alpha and beta)
%             e.g. for Joint 1 with traj_order being 5,
%                  x([1, 3, 5, 7, 9]) denotes coeff for sine: alpha
%                  x([2, 4, 6, 8, 10]) denotes coeff for cosine: beta
%                  x(11) denotes initial joint angle: q0
% @param[out] c: such that c <= 0
% @param[out] ceq: such that ceq = 0
% @dependency: forward_kine.m (forward kinematics for xMate3-Pro)
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

%% FORWARD KINEMATICS
ceq = [];
c = zeros(traj_n * 2, 1);
for k = 1:traj_n
	time = k * traj_Ts;
    ind = 2 * (k - 1) + 1;

    % compute tcp
	[opt_q, ~, ~] = traj_func(x, dof, time, traj_wf, traj_order);	% size:(dof, 1)
    [~, ~, tcp] = forward_kine(opt_q);

    % plain constraint: z>0 for any tcp
    c(ind) = 0.05 - tcp(3);

    % cylinder constraint: z<0.3 for any tcp in circle surrounding base
    % if tcp is within the specified cylinder, then
    %       0.05<z<0.3: 0.3-z>0, z>0.05
    %       radius(x, y)<0.2: 0.2-radius>0
    isInCircle = 0.2 - sqrt(tcp(1)^2 + tcp(2)^2);
    isUnderCeil = 0.3 - tcp(3);
    isAboveGnd = tcp(3) - 0.05;
    isInCylinder = abs(isInCircle * isUnderCeil * isAboveGnd);
    if ((isInCircle >= 0) && (isUnderCeil >= 0) && (isAboveGnd >= 0))
        c(ind + 1) = isInCylinder;
    else
        c(ind + 1) = -isInCylinder;
    end
end

rmpath('.\utils');
end