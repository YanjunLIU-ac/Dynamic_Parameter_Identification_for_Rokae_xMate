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

%% TEST TIME EXPENSE OF traj_func
tic
for cnt=1:1000
    A_ = zeros(21, 77);
    for k = 1:traj_n
        [q, qd, qdd] = traj_func(opt_x, dof, (k-1)*traj_Ts, traj_wf, traj_order);
    
	    s1 = sin(q(1)); c1 = cos(q(1)); 
	    s2 = sin(q(2)); c2 = cos(q(2));
	    s3 = sin(q(3)); c3 = cos(q(3));
	    s4 = sin(q(4)); c4 = cos(q(4));
	    s5 = sin(q(5)); c5 = cos(q(5));
	    s6 = sin(q(6)); c6 = cos(q(6));
	    s7 = sin(q(7)); c7 = cos(q(7));
    
	    dQ1 = qd(1); ddQ1 = qdd(1);
	    dQ2 = qd(2); ddQ2 = qdd(2);
	    dQ3 = qd(3); ddQ3 = qdd(3);
	    dQ4 = qd(4); ddQ4 = qdd(4);
	    dQ5 = qd(5); ddQ5 = qdd(5);
	    dQ6 = qd(6); ddQ6 = qdd(6);
	    dQ7 = qd(7); ddQ7 = qdd(7);
    end
end
toc

%% TEST TIME ELAPSE BETWEEN SYMS AND EXPRESSION
syms var_x
syms var_y

disp('time for syms:')
tic
fun_z = exp(log(exp(sin(var_x)) - exp(sin(var_x-var_y))) / log(cos(exp(var_x)) - cos(exp(var_x+var_y)))) * log(sin(var_y)/cos(var_x));
res_eval = eval(subs(fun_z, {'var_x', 'var_y'}, {154, 423}));
toc

disp('time for expression:')
tic
var_x = 154;
var_y = 423;
res_math = exp(log(exp(sin(var_x)) - exp(sin(var_x-var_y))) / log(cos(exp(var_x)) - cos(exp(var_x+var_y)))) * log(sin(var_y)/cos(var_x));
toc

disp(['difference: ', num2str(res_eval-res_math)]);