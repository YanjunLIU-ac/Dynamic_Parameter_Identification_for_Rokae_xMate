%% sinusoidal_traj.m
% @brief: compute trajectory based on sinusoidal function for references

traj_n = 20000;

%% LOAD ROBOT MODEL
LB = Link([0, 0, 0, 0], 'modified');   % fixed
L1 = Link([0, 0.3415, 0, 0], 'modified');
L2 = Link([0, 0, 0, -pi/2], 'modified');
L3 = Link([0, 0.394, 0, pi/2], 'modified');
L4 = Link([0, 0, 0, -pi/2], 'modified');
L5 = Link([0, 0.366, 0, pi/2], 'modified');
L6 = Link([0, 0, 0, -pi/2], 'modified');
L7 = Link([0, 0.2503, 0, pi/2], 'modified');
% L1.qlim([-170, 170] * pi / 180);
% L2.qlim([-120, 120] * pi / 180);
% L3.qlim([-170, 170] * pi / 180);
% L4.qlim([-120, 120] * pi / 180);
% L5.qlim([-170, 170] * pi / 180);
% L6.qlim([-120, 120] * pi / 180);
xm3p_modDH = SerialLink([LB, L1, L2, L3, L4, L5, L6, L7]);
xm3p_modDH.name = 'xMate3Pro-MDH';
xm3p_modDH.base = [1, 0, 0, 0; 0, 1, 0, 0; 0, 0, 1, 0; 0, 0, 0, 1];

%% SINUSOIDAL TRAJ
opt_q = zeros(traj_n, 7);
vel_q = zeros(traj_n, 7);
acc_q = zeros(traj_n, 7);
A = 7.5 * ones(1, 7);
T = 40 * ones(1, 7);

opt_q(1, :) = [0, pi/6, 0, pi/3, 0, pi/2, 0];
vel_q(1, :) = [0, 0, 0, 0, 0, 0, 0];
for n = 1:traj_n
    t = n / 1e-3;
    acc_q(n, :) = A .* sin(2*pi*n./T);
    
    if n < traj_n
        vel_q(n+1, :) = vel_q(n, :) + acc_q(n, :) * 0.001;
        opt_q(n+1, :) = opt_q(n, :) + vel_q(n+1, :) * 1e-3;
    end
end

% %% ANIMATION GIF OF EXCITATION TRAJECTORY
last_fpos = zeros(3, 1);
gap_pnts = zeros(3, 100);
for i = 1:20
    ind = 1000 * i;
    q = [0, opt_q(ind, 1), opt_q(ind, 2), opt_q(ind, 3), ...
         opt_q(ind, 4), opt_q(ind, 5), opt_q(ind, 6), opt_q(ind, 7)];
    xm3p_modDH.plot(q); hold on;     % animation
    fpos = xm3p_modDH.fkine(q);

    if i > 1
        gap_pnts(1, :) = linspace(last_fpos(1), fpos.t(1), 100);
        gap_pnts(2, :) = linspace(last_fpos(2), fpos.t(2), 100);
        gap_pnts(3, :) = linspace(last_fpos(3), fpos.t(3), 100);
        plot3(gap_pnts(1, :), gap_pnts(2, :), gap_pnts(3, :), 'r', 'LineWidth', 1.0);
    else
        plot3(fpos.t(1), fpos.t(2), fpos.t(3), 'r', 'LineWidth', 1.0);
    end

    zlim([0.05, 1.5]);
    xlim([-1, 1.5]);
    ylim([-1, 1.5]);
    title('激励轨迹仿真示意图', 'FontName', '宋体');
    last_fpos = [fpos.t(1), fpos.t(2), fpos.t(3)];
end