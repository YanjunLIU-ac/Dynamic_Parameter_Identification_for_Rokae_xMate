%% dynamics_friction_matrix.m
% @brief: compute friction matrix from dynamic equation, directly by arithmetic expression

F = sym(zeros(7, 1));
F(1) = fv1 * dQ1 + fc1 * sign(dQ1);
F(2) = fv2 * dQ2 + fc2 * sign(dQ2);
F(3) = fv3 * dQ3 + fc3 * sign(dQ3);
F(4) = fv4 * dQ4 + fc4 * sign(dQ4);
F(5) = fv5 * dQ5 + fc5 * sign(dQ5);
F(6) = fv6 * dQ6 + fc6 * sign(dQ6);
F(7) = fv7 * dQ7 + fc7 * sign(dQ7);

%% SAVE TO TXT
f1 = char(F(1)); 
f2 = char(F(2));
f3 = char(F(3)); 
f4 = char(F(4)); 
f5 = char(F(5));
f6 = char(F(6));
f7 = char(F(7));
fid = fopen('..\dynamics_friction_matrix.txt', 'w');
fprintf(fid, 'F1=%s\rF2=%s\rF3=%s\rF4=%s\rF5=%s\rF6=%s\rF7=%s\r', f1, f2, f3, f4, f5, f6, f7);
fclose(fid);