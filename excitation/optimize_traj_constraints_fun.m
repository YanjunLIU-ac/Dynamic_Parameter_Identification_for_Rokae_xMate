function [c, ceq] = optimize_traj_constraints_fun(x)
% @brief: figure out inequality and equality constraints
% @param[in]: hyper-parameter matrix (q_{0}, alpha and beta)
%             e.g. for Joint 1 with traj_order being 5,
%                  x([1, 3, 5, 7, 9]) denotes coeff for sine: alpha
%                  x([2, 4, 6, 8, 10]) denotes coeff for cosine: beta
%                  x(11) denotes initial joint angle: q0
% @param[out] c: such that c <= 0
% @param[out] ceq: such that ceq = 0
% @dependency: traj_func.m (Fourier-series based trajectory)

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
% initial configuration
q_init = [0; pi/6; 0; pi/3; 0; pi/2; 0];

%% constraints through trajectory function
c = [];

% inequality constraints
for k = 1:traj_n-1
	time = k * traj_Ts;
	[opt_q, opt_qd, opt_qdd] = traj_func(x, dof, time, traj_wf, traj_order);	% size:(dof, 1)

	Ax = [opt_q; opt_qd; opt_qdd; -opt_q; -opt_qd; -opt_qdd];
    b = [2.9671; 2.0944; 2.9671; 2.0944; 2.9671; 2.0944; 6.2832;
	     2.175; 2.175; 2.175; 2.175; 2.610; 2.610; 2.610;
		 15; 7.5; 10; 10; 15; 15; 20;
		 2.9671; 2.0944; 2.9671; 2.0944; 2.9671; 2.0944; 6.2832;
	     2.175; 2.175; 2.175; 2.175; 2.610; 2.610; 2.610;
		 15; 7.5; 10; 10; 15; 15; 20];
	c = [c; Ax - b];
end	
	
% equality constraints
[opt_q0, opt_qd0, opt_qdd0] = traj_func(x, dof, 0, traj_wf, traj_order);
[opt_qn, opt_qdn, opt_qddn] = traj_func(x, dof, traj_n*traj_Ts, traj_wf, traj_order);

Aeq = [opt_q0; opt_qd0; opt_qdd0; opt_qn; opt_qdn; opt_qddn];
beq = 0.00001 * ones(dof * 2 * 3, 1);
beq(1:7) = q_init;
beq(22:28) = q_init;
ceq = Aeq - beq;

end
