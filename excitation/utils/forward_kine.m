function [T, tip, rot] = forward_kine(q)
% @brief: figure out homogenous transformation matrix
% @param[in] q: joint angle vector (radian, joint 1~7)
% @param[out] T: homogenous transformation matrix (4×4 matrix)
% @param[out] tip: tool center tip, in x-y-z (3×1 vector, in m)
% @param[out] rot: rotation matrix (3×3 matrix)

% DH parameters (in m)
a = [0 0 0 0 0 0 0];
d = [0.3415 0 0.394 0 0.366 0 0.2503];
alpha = [0 -pi/2 pi/2 -pi/2 pi/2 -pi/2 pi/2];
theta = [q(1) q(2) q(3) q(4) q(5) q(6) q(7)];

% Transformation matrix
T = eye(4);
for i = 1:7
    t = eye(4);

    t(1, 1) = cos(theta(i));
    t(1, 2) = -sin(theta(i));
    t(1, 3) = 0;
    t(1, 4) = a(i);

    t(2, 1) = sin(theta(i)) * cos(alpha(i));
    t(2, 2) = cos(theta(i)) * cos(alpha(i));
    t(2, 3) = -sin(alpha(i));
    t(2, 4) = -d(i) * sin(alpha(i));

    t(3, 1) = sin(theta(i)) * sin(alpha(i));
    t(3, 2) = cos(theta(i)) * sin(alpha(i));
    t(3, 3) = cos(alpha(i));
    t(3, 4) = d(i) * cos(alpha(i));
    
    T = T * t;
end
tip = [T(1,4); T(2,4); T(3,4)];
rot = T(1:3, 1:3);