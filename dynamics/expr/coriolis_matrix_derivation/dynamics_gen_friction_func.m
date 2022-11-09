%% dynamics_friction_matrix.m
% @brief: compute friction matrix from dynamic equation, directly by arithmetic expression
function F = dynamics_gen_friction_func(dQ, ...
                                        fv1, fv2, fv3, fv4, fv5, fv6, fv7, ...
                                        fc1, fc2, fc3, fc4, fc5, fc6, fc7)
F = sym(zeros(7, 1));
F(1) = fv1 * dQ(1) + fc1 * sign(dQ(1));
F(2) = fv2 * dQ(2) + fc2 * sign(dQ(2));
F(3) = fv3 * dQ(3) + fc3 * sign(dQ(3));
F(4) = fv4 * dQ(4) + fc4 * sign(dQ(4));
F(5) = fv5 * dQ(5) + fc5 * sign(dQ(5));
F(6) = fv6 * dQ(6) + fc6 * sign(dQ(6));
F(7) = fv7 * dQ(7) + fc7 * sign(dQ(7));