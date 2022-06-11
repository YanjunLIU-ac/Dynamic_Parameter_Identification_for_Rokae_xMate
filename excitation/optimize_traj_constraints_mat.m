function [A, b, Aeq, beq] = optimize_traj_constraints_mat(wf, Ts, N)
% @brief: figure out fourier-based series coeffs for q, qd, qdd
%         (Refer to `Study on Parameter Identification for Rokae XB4`)
% @param[in] wf: trajectory fundamental frequency in radian
% @param[in] Ts: sampling period
% @param[in] N: number of sampling points
% @param[out] A, b: inequality constraints, where matrix A(3*7*2*N, 77) and vector b(3*7*2*N, 1)
%                   s.t. |q|<q_max, |qd|<qd_max, |qdd|<qdd_max 
% @param[out] Aeq, beq: equality constraints, where matrix A(3*7*2, 77) and vector b(3*7*2, 1)
%                       s.t. q0=qn=q_init, qd0=qdn=0, qdd0=qddn=0

% zeros row vector of specified length
% o11 = zeros(1, 11);
o7 = zeros(7, 1) * 1e-4;
% initial configuration
q_init = [0; pi/6; 0; pi/3; 0; pi/2; 0];

A_ = zeros(7*3, 77);
A = zeros(7*2*3*(N-1), 77); b = zeros(7*2*3*(N-1), 1);
Aeq = zeros(7*3*2, 77); beq = zeros(7*3*2, 1);

for k = 0:N
	time = k * Ts;

	% fourier-series coeffs for q (1x11)
	qs = [sin(wf * time * 1)/(wf * 1), -cos(wf * time * 1)/(wf * 1), ...
		  sin(wf * time * 2)/(wf * 2), -cos(wf * time * 2)/(wf * 2), ...
		  sin(wf * time * 3)/(wf * 3), -cos(wf * time * 3)/(wf * 3), ...
		  sin(wf * time * 4)/(wf * 4), -cos(wf * time * 4)/(wf * 4), ...
	      sin(wf * time * 5)/(wf * 5), -cos(wf * time * 5)/(wf * 5), 1];
	
	% fourier-series coeffs for qd (1x11)
	qds = [cos(wf * time * 1), sin(wf * time * 1), ...
           cos(wf * time * 2), sin(wf * time * 2), ...
	       cos(wf * time * 3), sin(wf * time * 3), ...
	       cos(wf * time * 4), sin(wf * time * 4), ...
	       cos(wf * time * 5), sin(wf * time * 5), 0];

    % fourier-series coeffs for qdd (1x11)
	qdds = [-wf * 1 * sin(wf * time * 1), wf * 1 * cos(wf * time * 1), ...
            -wf * 2 * sin(wf * time * 2), wf * 2 * cos(wf * time * 2), ...
	        -wf * 3 * sin(wf * time * 3), wf * 3 * cos(wf * time * 3), ...
	        -wf * 4 * sin(wf * time * 4), wf * 4 * cos(wf * time * 4), ...
	        -wf * 5 * sin(wf * time * 5), wf * 5 * cos(wf * time * 5), 0];
    
    for j = 1:7
        s_col = 11 * (j - 1) + 1; e_col = 11 * j;
        A_(j, s_col:e_col) = qs;
        A_(7 + j, s_col:e_col) = qds;
        A_(14 + j, s_col:e_col) = qdds;
    end

    if (k >= 1 && k <= N-1)     % INEQUALITY CONSTRAINTS s.t. Ax<b
	    b_ = [2.9671; 2.0944; 2.9671; 2.0944; 2.9671; 2.0944; 6.2832;
	          2.175; 2.175; 2.175; 2.175; 2.610; 2.610; 2.610;
		      15; 7.5; 10; 10; 15; 15; 20;
		      2.9671; 2.0944; 2.9671; 2.0944; 2.9671; 2.0944; 6.2832;
	          2.175; 2.175; 2.175; 2.175; 2.610; 2.610; 2.610;
		      15; 7.5; 10; 10; 15; 15; 20];
	    
        % b = [q1, q2, q3, q4, q5, q6, q7, qd1, qd2, qd3, qd4, qd5, qd6, qd7,
        %      qdd1, qdd2, qdd3, qdd4, qdd5, qdd6, qdd7]

        s_ind = 42 * (k-1) + 1; e_ind = 42 * k;
        b(s_ind:e_ind, :) = b_;
        A(s_ind:e_ind, :) = [A_; -A_];
    elseif (k == 0)     % EQUALITY CONSTRAINTS s.t. A(q0, qd0, qdd0)x=b_init
		beq_ = [q_init; o7; o7];

        beq(1:21, :) = beq_;
        Aeq(1:21, :) = A_;
    elseif (k == N)     % EQUALITY CONSTRAINTS s.t. A(qn, qdn, qddn)x=b_init
        beq_ = [q_init; o7; o7];

        Aeq(22:42, :) = A_;
        beq(22:42, :) = beq_;
    end
end

end

% A_ = [qs, o11, o11, o11, o11, o11, o11;
%       o11, qs, o11, o11, o11, o11, o11;
%       o11, o11, qs, o11, o11, o11, o11;
%       o11, o11, o11, qs, o11, o11, o11;
%       o11, o11, o11, o11, qs, o11, o11;
%       o11, o11, o11, o11, o11, qs, o11;
%       o11, o11, o11, o11, o11, o11, qs;
%       qds, o11, o11, o11, o11, o11, o11;
%       o11, qds, o11, o11, o11, o11, o11;
%       o11, o11, qds, o11, o11, o11, o11;
%       o11, o11, o11, qds, o11, o11, o11;
%       o11, o11, o11, o11, qds, o11, o11;
%       o11, o11, o11, o11, o11, qds, o11;
%       o11, o11, o11, o11, o11, o11, qds; 
%       qdds, o11, o11, o11, o11, o11, o11;
%       o11, qdds, o11, o11, o11, o11, o11;
%       o11, o11, qdds, o11, o11, o11, o11;
%       o11, o11, o11, qdds, o11, o11, o11;
%       o11, o11, o11, o11, qdds, o11, o11;
%       o11, o11, o11, o11, o11, qdds, o11;
%       o11, o11, o11, o11, o11, o11, qdds];