%% dynamics_inertia_matrix.m
% @brief: compute inertia matrix from dynamic equation
%         for each joint: inertia vector is 1x7, inertial torque is a scalar
%         		[m1, m2, m3, m4, m5, m6, m7] * [qdd1, qdd2, qdd3, qdd4, qdd5, qdd6, qdd7]' = M
%         thus, for manipulator with 7 joints, the inertia matrix should be 7x7 for 7 inertia torques

%% LINEARIZATION
M = sym(zeros(7, 7));
for ii = 1:7	% for each element in inertia vector
	Q_ = zeros(7, 1);
	Q_(ii) = 1;
	for jj = 1:7	% for each joint
		M(jj, ii) = subs(TAU(jj), ...
		                {'ddQ1', 'ddQ2', 'ddQ3', 'ddQ4', 'ddQ5', 'ddQ6', 'ddQ7', ...
						 'dQ1', 'dQ2', 'dQ3', 'dQ4', 'dQ5', 'dQ6', 'dQ7', ...
						 'fe1', 'fe2', 'fe3', 'ne1', 'ne2', 'ne3', 'g', ...
						 'fv1', 'fv2', 'fv3', 'fv4', 'fv5', 'fv6', 'fv7', ...
						 'fc1', 'fc2', 'fc3', 'fc4', 'fc5', 'fc6', 'fc7'}, ...
						 {Q_(1), Q_(2), Q_(3), Q_(4), Q_(5), Q_(6), Q_(7), ...
						  0, 0, 0, 0, 0, 0, 0, ...
						  0, 0, 0, 0, 0, 0, 0, ...
						  0, 0, 0, 0, 0, 0, 0, ...
						  0, 0, 0, 0, 0, 0, 0});
	end
end

%% SAVE TO FILE
fid = fopen('..\dynamics_inertia_matrix.txt', 'w');
fprintf(fid, 'M=[');
for i = 1:7
    if (i < 7)
        fprintf(fid, '%s,%s,%s,%s,%s,%s,%s;\r', char(M(i,1)), char(M(i,2)), char(M(i,3)), char(M(i,4)), char(M(i,5)), char(M(i,6)), char(M(i,7)));
    else
        fprintf(fid, '%s,%s,%s,%s,%s,%s,%s]\r', char(M(i,1)), char(M(i,2)), char(M(i,3)), char(M(i,4)), char(M(i,5)), char(M(i,6)), char(M(i,7)));
    end
end
fclose(fid);
