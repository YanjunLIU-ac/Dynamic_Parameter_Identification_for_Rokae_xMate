%% dynamics_gravity_matrix.m
% @brief: compute gravity matrix from dynamic equation
%         for each joint: gravitional vector is 7x1 and gravitional torque is 7x1
%         		[g1, g2, g3, g4, g5, g6, g7] * g = G
%         thus, for manipulator with 7 joints, the gravity matrix should be 7x1

%% LINEARIZATION
G = sym(zeros(7, 1));
for ii = 1:7	% for each joint
	G(ii) = subs(TAU(ii), ...
				{'ddQ1', 'ddQ2', 'ddQ3', 'ddQ4', 'ddQ5', 'ddQ6', 'ddQ7', ...
				 'dQ1', 'dQ2', 'dQ3', 'dQ4', 'dQ5', 'dQ6', 'dQ7', ...
				 'fe1', 'fe2', 'fe3', 'ne1', 'ne2', 'ne3', ...
				 'fv1', 'fv2', 'fv3', 'fv4', 'fv5', 'fv6', 'fv7', ...
				 'fc1', 'fc2', 'fc3', 'fc4', 'fc5', 'fc6', 'fc7'}, ...
				 {0, 0, 0, 0, 0, 0, 0, ...
				  0, 0, 0, 0, 0, 0, 0, ...
				  0, 0, 0, 0, 0, 0, ...
				  0, 0, 0, 0, 0, 0, 0, ...
				  0, 0, 0, 0, 0, 0, 0});
end

%% SAVE TO TXT
fid = fopen('..\dynamics_gravity_matrix.txt', 'w');
fprintf(fid, 'G=[');
for ii = 1:7
    if (ii < 7)
        fprintf(fid, '%s;\r', char(G(ii)));
    else
        fprintf(fid, '%s]\r', char(G(ii)));
    end
end
fclose(fid);

