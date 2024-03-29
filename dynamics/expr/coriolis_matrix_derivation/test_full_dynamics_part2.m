%% test_full_dynamics_part2.m

%% figure out reference holistic torque
TAU = dynamics_full_solve;
TT = zeros(7, 1);
for k = 1:7
    TT(k) = eval(subs(TAU(k), ...
                     {'m1', 'mc11', 'mc12', 'mc13', 'Ic111', 'Ic122', 'Ic133', 'Ic112', 'Ic113', 'Ic123', 'Ia1', 'fv1', 'fc1', ...
                      'm2', 'mc21', 'mc22', 'mc23', 'Ic211', 'Ic222', 'Ic233', 'Ic212', 'Ic213', 'Ic223', 'Ia2', 'fv2', 'fc2', ...
                      'm3', 'mc31', 'mc32', 'mc33', 'Ic311', 'Ic322', 'Ic333', 'Ic312', 'Ic313', 'Ic323', 'Ia3', 'fv3', 'fc3', ...
                      'm4', 'mc41', 'mc42', 'mc43', 'Ic411', 'Ic422', 'Ic433', 'Ic412', 'Ic413', 'Ic423', 'Ia4', 'fv4', 'fc4', ...
                      'm5', 'mc51', 'mc52', 'mc53', 'Ic511', 'Ic522', 'Ic533', 'Ic512', 'Ic513', 'Ic523', 'Ia5', 'fv5', 'fc5', ...
                      'm6', 'mc61', 'mc62', 'mc63', 'Ic611', 'Ic622', 'Ic633', 'Ic612', 'Ic613', 'Ic623', 'Ia6', 'fv6', 'fc6', ...
                      'm7', 'mc71', 'mc72', 'mc73', 'Ic711', 'Ic722', 'Ic733', 'Ic712', 'Ic713', 'Ic723', 'Ia7', 'fv7', 'fc7', ...
                      's1', 'c1', 's2', 'c2', 's3', 'c3', 's4', 'c4', 's5', 'c5', 's6', 'c6', 's7', 'c7', ...
					  'dQ1', 'dQ2', 'dQ3', 'dQ4', 'dQ5', 'dQ6', 'dQ7', ...
					  'ddQ1', 'ddQ2', 'ddQ3', 'ddQ4', 'ddQ5', 'ddQ6', 'ddQ7', ...
					  'fe1', 'fe2', 'fe3',  'ne1', 'ne2', 'ne3', ...
					  'g', 'd1', 'd3', 'd5', 'd7'}, ...
					  {m1, mc11, mc12, mc13, Ic111, Ic122, Ic133, Ic112, Ic113, Ic123, Ia1, fv1, fc1, ...
					   m2, mc21, mc22, mc23, Ic211, Ic222, Ic233, Ic212, Ic213, Ic223, Ia2, fv2, fc2, ...
					   m3, mc31, mc32, mc33, Ic311, Ic322, Ic333, Ic312, Ic313, Ic323, Ia3, fv3, fc3, ...
					   m4, mc41, mc42, mc43, Ic411, Ic422, Ic433, Ic412, Ic413, Ic423, Ia4, fv4, fc4, ...
					   m5, mc51, mc52, mc53, Ic511, Ic522, Ic533, Ic512, Ic513, Ic523, Ia5, fv5, fc5, ...
					   m6, mc61, mc62, mc63, Ic611, Ic622, Ic633, Ic612, Ic613, Ic623, Ia6, fv6, fc6, ...
					   m7, mc71, mc72, mc73, Ic711, Ic722, Ic733, Ic712, Ic713, Ic723, Ia7, fv7, fc7, ...
					   s1, c1, s2, c2, s3, c3, s4, c4, s5, c5, s6, c6, s7, c7, ...
					   dQ1, dQ2, dQ3, dQ4, dQ5, dQ6, dQ7, ...
					   ddQ1, ddQ2, ddQ3, ddQ4, ddQ5, ddQ6, ddQ7, ...
					   fe1, fe2, fe3, ne1, ne2, ne3, ...
					   g, d1, d3, d5, d7}));
end
disp('<INFO> Full Torque SUBSTITUTED!!');

%% inertia torque
M = dynamics_gen_inertia_matrix(TAU);
MM = zeros(7, 7);
for i = 1:7
    for j = 1:7
    MM(i, j) = eval(subs(M(i, j), ...
                     {'m1', 'mc11', 'mc12', 'mc13', 'Ic111', 'Ic122', 'Ic133', 'Ic112', 'Ic113', 'Ic123', 'Ia1', 'fv1', 'fc1', ...
                      'm2', 'mc21', 'mc22', 'mc23', 'Ic211', 'Ic222', 'Ic233', 'Ic212', 'Ic213', 'Ic223', 'Ia2', 'fv2', 'fc2', ...
                      'm3', 'mc31', 'mc32', 'mc33', 'Ic311', 'Ic322', 'Ic333', 'Ic312', 'Ic313', 'Ic323', 'Ia3', 'fv3', 'fc3', ...
                      'm4', 'mc41', 'mc42', 'mc43', 'Ic411', 'Ic422', 'Ic433', 'Ic412', 'Ic413', 'Ic423', 'Ia4', 'fv4', 'fc4', ...
                      'm5', 'mc51', 'mc52', 'mc53', 'Ic511', 'Ic522', 'Ic533', 'Ic512', 'Ic513', 'Ic523', 'Ia5', 'fv5', 'fc5', ...
                      'm6', 'mc61', 'mc62', 'mc63', 'Ic611', 'Ic622', 'Ic633', 'Ic612', 'Ic613', 'Ic623', 'Ia6', 'fv6', 'fc6', ...
                      'm7', 'mc71', 'mc72', 'mc73', 'Ic711', 'Ic722', 'Ic733', 'Ic712', 'Ic713', 'Ic723', 'Ia7', 'fv7', 'fc7', ...
                      's1', 'c1', 's2', 'c2', 's3', 'c3', 's4', 'c4', 's5', 'c5', 's6', 'c6', 's7', 'c7', ...
					  'dQ1', 'dQ2', 'dQ3', 'dQ4', 'dQ5', 'dQ6', 'dQ7', ...
					  'ddQ1', 'ddQ2', 'ddQ3', 'ddQ4', 'ddQ5', 'ddQ6', 'ddQ7', ...
					  'fe1', 'fe2', 'fe3',  'ne1', 'ne2', 'ne3', ...
					  'g', 'd1', 'd3', 'd5', 'd7'}, ...
					  {m1, mc11, mc12, mc13, Ic111, Ic122, Ic133, Ic112, Ic113, Ic123, Ia1, fv1, fc1, ...
					   m2, mc21, mc22, mc23, Ic211, Ic222, Ic233, Ic212, Ic213, Ic223, Ia2, fv2, fc2, ...
					   m3, mc31, mc32, mc33, Ic311, Ic322, Ic333, Ic312, Ic313, Ic323, Ia3, fv3, fc3, ...
					   m4, mc41, mc42, mc43, Ic411, Ic422, Ic433, Ic412, Ic413, Ic423, Ia4, fv4, fc4, ...
					   m5, mc51, mc52, mc53, Ic511, Ic522, Ic533, Ic512, Ic513, Ic523, Ia5, fv5, fc5, ...
					   m6, mc61, mc62, mc63, Ic611, Ic622, Ic633, Ic612, Ic613, Ic623, Ia6, fv6, fc6, ...
					   m7, mc71, mc72, mc73, Ic711, Ic722, Ic733, Ic712, Ic713, Ic723, Ia7, fv7, fc7, ...
					   s1, c1, s2, c2, s3, c3, s4, c4, s5, c5, s6, c6, s7, c7, ...
					   dQ1, dQ2, dQ3, dQ4, dQ5, dQ6, dQ7, ...
					   ddQ1, ddQ2, ddQ3, ddQ4, ddQ5, ddQ6, ddQ7, ...
					   fe1, fe2, fe3, ne1, ne2, ne3, ...
					   g, d1, d3, d5, d7}));
    end
end
disp('<INFO> Inertial Matrix SUBSTITUTED!!');

%% gravity torque
G = dynamics_gen_gravity_matrix(TAU);
GG = zeros(7, 1);
for k = 1:7
    GG(k) = eval(subs(G(k), ...
                     {'m1', 'mc11', 'mc12', 'mc13', 'Ic111', 'Ic122', 'Ic133', 'Ic112', 'Ic113', 'Ic123', 'Ia1', 'fv1', 'fc1', ...
                      'm2', 'mc21', 'mc22', 'mc23', 'Ic211', 'Ic222', 'Ic233', 'Ic212', 'Ic213', 'Ic223', 'Ia2', 'fv2', 'fc2', ...
                      'm3', 'mc31', 'mc32', 'mc33', 'Ic311', 'Ic322', 'Ic333', 'Ic312', 'Ic313', 'Ic323', 'Ia3', 'fv3', 'fc3', ...
                      'm4', 'mc41', 'mc42', 'mc43', 'Ic411', 'Ic422', 'Ic433', 'Ic412', 'Ic413', 'Ic423', 'Ia4', 'fv4', 'fc4', ...
                      'm5', 'mc51', 'mc52', 'mc53', 'Ic511', 'Ic522', 'Ic533', 'Ic512', 'Ic513', 'Ic523', 'Ia5', 'fv5', 'fc5', ...
                      'm6', 'mc61', 'mc62', 'mc63', 'Ic611', 'Ic622', 'Ic633', 'Ic612', 'Ic613', 'Ic623', 'Ia6', 'fv6', 'fc6', ...
                      'm7', 'mc71', 'mc72', 'mc73', 'Ic711', 'Ic722', 'Ic733', 'Ic712', 'Ic713', 'Ic723', 'Ia7', 'fv7', 'fc7', ...
                      's1', 'c1', 's2', 'c2', 's3', 'c3', 's4', 'c4', 's5', 'c5', 's6', 'c6', 's7', 'c7', ...
					  'dQ1', 'dQ2', 'dQ3', 'dQ4', 'dQ5', 'dQ6', 'dQ7', ...
					  'ddQ1', 'ddQ2', 'ddQ3', 'ddQ4', 'ddQ5', 'ddQ6', 'ddQ7', ...
					  'fe1', 'fe2', 'fe3',  'ne1', 'ne2', 'ne3', ...
					  'g', 'd1', 'd3', 'd5', 'd7'}, ...
					  {m1, mc11, mc12, mc13, Ic111, Ic122, Ic133, Ic112, Ic113, Ic123, Ia1, fv1, fc1, ...
					   m2, mc21, mc22, mc23, Ic211, Ic222, Ic233, Ic212, Ic213, Ic223, Ia2, fv2, fc2, ...
					   m3, mc31, mc32, mc33, Ic311, Ic322, Ic333, Ic312, Ic313, Ic323, Ia3, fv3, fc3, ...
					   m4, mc41, mc42, mc43, Ic411, Ic422, Ic433, Ic412, Ic413, Ic423, Ia4, fv4, fc4, ...
					   m5, mc51, mc52, mc53, Ic511, Ic522, Ic533, Ic512, Ic513, Ic523, Ia5, fv5, fc5, ...
					   m6, mc61, mc62, mc63, Ic611, Ic622, Ic633, Ic612, Ic613, Ic623, Ia6, fv6, fc6, ...
					   m7, mc71, mc72, mc73, Ic711, Ic722, Ic733, Ic712, Ic713, Ic723, Ia7, fv7, fc7, ...
					   s1, c1, s2, c2, s3, c3, s4, c4, s5, c5, s6, c6, s7, c7, ...
					   dQ1, dQ2, dQ3, dQ4, dQ5, dQ6, dQ7, ...
					   ddQ1, ddQ2, ddQ3, ddQ4, ddQ5, ddQ6, ddQ7, ...
					   fe1, fe2, fe3, ne1, ne2, ne3, ...
					   g, d1, d3, d5, d7}));
end
disp('<INFO> Gravity Torque SUBSTITUTED!!');

%% Friction
F = dynamics_gen_friction_matrix([dQ1, dQ2, dQ3, dQ4, dQ5, dQ6, dQ7], ...
                                 fv1, fv2, fv3, fv4, fv5, fv6, fv7, ...
                                 fc1, fc2, fc3, fc4, fc5, fc6, fc7);
FF = zeros(7, 1);
for k = 1:7
    FF(k) = eval(subs(F(k), ...
                     {'m1', 'mc11', 'mc12', 'mc13', 'Ic111', 'Ic122', 'Ic133', 'Ic112', 'Ic113', 'Ic123', 'Ia1', 'fv1', 'fc1', ...
                      'm2', 'mc21', 'mc22', 'mc23', 'Ic211', 'Ic222', 'Ic233', 'Ic212', 'Ic213', 'Ic223', 'Ia2', 'fv2', 'fc2', ...
                      'm3', 'mc31', 'mc32', 'mc33', 'Ic311', 'Ic322', 'Ic333', 'Ic312', 'Ic313', 'Ic323', 'Ia3', 'fv3', 'fc3', ...
                      'm4', 'mc41', 'mc42', 'mc43', 'Ic411', 'Ic422', 'Ic433', 'Ic412', 'Ic413', 'Ic423', 'Ia4', 'fv4', 'fc4', ...
                      'm5', 'mc51', 'mc52', 'mc53', 'Ic511', 'Ic522', 'Ic533', 'Ic512', 'Ic513', 'Ic523', 'Ia5', 'fv5', 'fc5', ...
                      'm6', 'mc61', 'mc62', 'mc63', 'Ic611', 'Ic622', 'Ic633', 'Ic612', 'Ic613', 'Ic623', 'Ia6', 'fv6', 'fc6', ...
                      'm7', 'mc71', 'mc72', 'mc73', 'Ic711', 'Ic722', 'Ic733', 'Ic712', 'Ic713', 'Ic723', 'Ia7', 'fv7', 'fc7', ...
                      's1', 'c1', 's2', 'c2', 's3', 'c3', 's4', 'c4', 's5', 'c5', 's6', 'c6', 's7', 'c7', ...
					  'dQ1', 'dQ2', 'dQ3', 'dQ4', 'dQ5', 'dQ6', 'dQ7', ...
					  'ddQ1', 'ddQ2', 'ddQ3', 'ddQ4', 'ddQ5', 'ddQ6', 'ddQ7', ...
					  'fe1', 'fe2', 'fe3',  'ne1', 'ne2', 'ne3', ...
					  'g', 'd1', 'd3', 'd5', 'd7'}, ...
					  {m1, mc11, mc12, mc13, Ic111, Ic122, Ic133, Ic112, Ic113, Ic123, Ia1, fv1, fc1, ...
					   m2, mc21, mc22, mc23, Ic211, Ic222, Ic233, Ic212, Ic213, Ic223, Ia2, fv2, fc2, ...
					   m3, mc31, mc32, mc33, Ic311, Ic322, Ic333, Ic312, Ic313, Ic323, Ia3, fv3, fc3, ...
					   m4, mc41, mc42, mc43, Ic411, Ic422, Ic433, Ic412, Ic413, Ic423, Ia4, fv4, fc4, ...
					   m5, mc51, mc52, mc53, Ic511, Ic522, Ic533, Ic512, Ic513, Ic523, Ia5, fv5, fc5, ...
					   m6, mc61, mc62, mc63, Ic611, Ic622, Ic633, Ic612, Ic613, Ic623, Ia6, fv6, fc6, ...
					   m7, mc71, mc72, mc73, Ic711, Ic722, Ic733, Ic712, Ic713, Ic723, Ia7, fv7, fc7, ...
					   s1, c1, s2, c2, s3, c3, s4, c4, s5, c5, s6, c6, s7, c7, ...
					   dQ1, dQ2, dQ3, dQ4, dQ5, dQ6, dQ7, ...
					   ddQ1, ddQ2, ddQ3, ddQ4, ddQ5, ddQ6, ddQ7, ...
					   fe1, fe2, fe3, ne1, ne2, ne3, ...
					   g, d1, d3, d5, d7}));
end
disp('<INFO> Friction Torque SUBSTITUTED!!');

%% coriolis torque
C = dynamics_gen_coriolis_matrix(TAU);
CC = zeros(7, 7, 7);
for k = 1:7
    CC(:, :, k) = eval(subs(C(:, :, k), ...
                     {'m1', 'mc11', 'mc12', 'mc13', 'Ic111', 'Ic122', 'Ic133', 'Ic112', 'Ic113', 'Ic123', 'Ia1', 'fv1', 'fc1', ...
                      'm2', 'mc21', 'mc22', 'mc23', 'Ic211', 'Ic222', 'Ic233', 'Ic212', 'Ic213', 'Ic223', 'Ia2', 'fv2', 'fc2', ...
                      'm3', 'mc31', 'mc32', 'mc33', 'Ic311', 'Ic322', 'Ic333', 'Ic312', 'Ic313', 'Ic323', 'Ia3', 'fv3', 'fc3', ...
                      'm4', 'mc41', 'mc42', 'mc43', 'Ic411', 'Ic422', 'Ic433', 'Ic412', 'Ic413', 'Ic423', 'Ia4', 'fv4', 'fc4', ...
                      'm5', 'mc51', 'mc52', 'mc53', 'Ic511', 'Ic522', 'Ic533', 'Ic512', 'Ic513', 'Ic523', 'Ia5', 'fv5', 'fc5', ...
                      'm6', 'mc61', 'mc62', 'mc63', 'Ic611', 'Ic622', 'Ic633', 'Ic612', 'Ic613', 'Ic623', 'Ia6', 'fv6', 'fc6', ...
                      'm7', 'mc71', 'mc72', 'mc73', 'Ic711', 'Ic722', 'Ic733', 'Ic712', 'Ic713', 'Ic723', 'Ia7', 'fv7', 'fc7', ...
                      's1', 'c1', 's2', 'c2', 's3', 'c3', 's4', 'c4', 's5', 'c5', 's6', 'c6', 's7', 'c7', ...
					  'dQ1', 'dQ2', 'dQ3', 'dQ4', 'dQ5', 'dQ6', 'dQ7', ...
					  'ddQ1', 'ddQ2', 'ddQ3', 'ddQ4', 'ddQ5', 'ddQ6', 'ddQ7', ...
					  'fe1', 'fe2', 'fe3',  'ne1', 'ne2', 'ne3', ...
					  'g', 'd1', 'd3', 'd5', 'd7'}, ...
					  {m1, mc11, mc12, mc13, Ic111, Ic122, Ic133, Ic112, Ic113, Ic123, Ia1, fv1, fc1, ...
					   m2, mc21, mc22, mc23, Ic211, Ic222, Ic233, Ic212, Ic213, Ic223, Ia2, fv2, fc2, ...
					   m3, mc31, mc32, mc33, Ic311, Ic322, Ic333, Ic312, Ic313, Ic323, Ia3, fv3, fc3, ...
					   m4, mc41, mc42, mc43, Ic411, Ic422, Ic433, Ic412, Ic413, Ic423, Ia4, fv4, fc4, ...
					   m5, mc51, mc52, mc53, Ic511, Ic522, Ic533, Ic512, Ic513, Ic523, Ia5, fv5, fc5, ...
					   m6, mc61, mc62, mc63, Ic611, Ic622, Ic633, Ic612, Ic613, Ic623, Ia6, fv6, fc6, ...
					   m7, mc71, mc72, mc73, Ic711, Ic722, Ic733, Ic712, Ic713, Ic723, Ia7, fv7, fc7, ...
					   s1, c1, s2, c2, s3, c3, s4, c4, s5, c5, s6, c6, s7, c7, ...
					   dQ1, dQ2, dQ3, dQ4, dQ5, dQ6, dQ7, ...
					   ddQ1, ddQ2, ddQ3, ddQ4, ddQ5, ddQ6, ddQ7, ...
					   fe1, fe2, fe3, ne1, ne2, ne3, ...
					   g, d1, d3, d5, d7}));
end
disp('<INFO> Coriolis Matrix SUBSTITUTED!!');