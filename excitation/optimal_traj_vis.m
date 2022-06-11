%% optimal_traj_vis.m
% @brief: plot joint {q, qd, qdd} on optimal trajectory
%         and validate reachable space in Robotics Toolbox

close all;
addpath('.\utils\')
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
% load optimal parameter
load('.\data\opt_x_lie.mat');
% load('.\data\opt_x.mat');

%% TRAJECTORY COMPUTATION (FOURIER-BASED)
% opt_q = zeros(traj_n, dof);
% opt_qd = zeros(traj_n, dof);
% opt_qdd = zeros(traj_n, dof);
% for k = 1:traj_n
%     time = (k-1) * traj_Ts;
%     [opt_q(k,:), opt_qd(k,:), opt_qdd(k,:)] = traj_func(opt_x_lie, dof, time, traj_wf, traj_order);
%     % [opt_q(k,:), opt_qd(k,:), opt_qdd(k,:)] = traj_func(0.3 * opt_x, dof, time, traj_wf, traj_order);
% end

%% TRAJECTORY COMPUTATION (SINUSOIDAL)
opt_q = zeros(traj_n, dof);
opt_qd = zeros(traj_n, dof);
opt_qdd = zeros(traj_n, dof);
opt_q(1, :) = [0, pi/6, 0, pi/3, 0, pi/2, 0]';
A = [2.21, -2.21, 1.2, -2.1, -2.3, 2.1, -2.5];
Ti = [3.68, 2.04, 2.98, 1.75, 4.43, 2.749, 1.06];
for k = 0:1:traj_n-1
    opt_qd(k+1, :) = A .* sin(2 * pi * 0.1 * k ./ Ti);
    if k < traj_n && k > 0
        opt_q(k+1, :) = opt_q(k, :) + opt_qd(k+1, :) * 0.1;
    end
    if k > 0
        opt_qdd(k+1, :) = (opt_q(k+1, :) - opt_q(k, :)) / 0.1;
    end
end

%% PLOTTING CURVES
% t = linspace(0, traj_n, traj_n) * traj_Ts;
% % joint angle: q
% figure(1); 
% set(gcf,'position',[0.1,0.1,0.9,0.9] );
% set(gcf,'unit','centimeters','position',[1,2,20,15]);
% plot(t, opt_q(:, 1), 'r', ...
%      t, opt_q(:, 2), 'c', ...
% 	 t, opt_q(:, 3), 'y', ...
% 	 t, opt_q(:, 4), 'g', ...
% 	 t, opt_q(:, 5), 'b', ...
% 	 t, opt_q(:, 6), 'm', ...
%      t, opt_q(:, 7), 'LineWidth', 1.0);
% title('激励轨迹关节角度曲线'); xlabel('时间(s)'); ylabel('角度(rad)');
% legend('关节1', '关节2', '关节3', '关节4', '关节5', '关节6', '关节7');
% print -f1 -dpng -r600 figs\train\exJointRad.png
% % joint velocity: qd
% figure(2);
% set(gcf,'position',[0.1,0.1,0.9,0.9] );
% set(gcf,'unit','centimeters','position',[1,2,20,15]);
% plot(t, opt_qd(:, 1), 'r', ...
%      t, opt_qd(:, 2), 'c', ...
% 	 t, opt_qd(:, 3), 'y', ...
% 	 t, opt_qd(:, 4), 'g', ...
% 	 t, opt_qd(:, 5), 'b', ...
% 	 t, opt_qd(:, 6), 'm', ...
%      t, opt_qd(:, 7), 'LineWidth', 1.0);
% title('激励轨迹关节角速度曲线'); xlabel('时间(s)'); ylabel('角速度(rad/s)');
% legend('关节1', '关节2', '关节3', '关节4', '关节5', '关节6', '关节7');
% print -f2 -dpng -r600 figs\train\exJointVel.png
% % joint acceleration: qdd
% figure(3); 
% set(gcf,'position',[0.1,0.1,0.9,0.9] );
% set(gcf,'unit','centimeters','position',[1,2,20,15]);
% plot(t, opt_qdd(:, 1), 'r', ...
%      t, opt_qdd(:, 2), 'c', ...
% 	 t, opt_qdd(:, 3), 'y', ...
% 	 t, opt_qdd(:, 4), 'g', ...
% 	 t, opt_qdd(:, 5), 'b', ...
% 	 t, opt_qdd(:, 6), 'm', ...
%      t, opt_qdd(:, 7), 'LineWidth', 1.0);
% title('激励轨迹关节角加速度曲线'); xlabel('时间(s)'); ylabel('角加速度(rad/s^2)');
% legend('关节1', '关节2', '关节3', '关节4', '关节5', '关节6', '关节7');
% print -f3 -dpng -r600 figs\train\exJointAcc.png

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
% xm3p_modDH.base = [1, 0, 0, 0; 0, 1, 0, 0; 0, 0, 1, 0; 0, 0, 0, 1];
% xm3p_modDH.display();
% figure(4); hold on;
% xm3p_modDH.plot([0, 0, pi/6, 0, pi/3, 0, pi/2, 0]); hold on;

%% 3D POSTURE OF EXCITATION TRAJECTORY
% for i = 1:traj_n
% 	fkine = xm3p_modDH.fkine([0, opt_q(i, 1), opt_q(i, 2), opt_q(i, 3), opt_q(i, 4), ...
% 							  opt_q(i, 5), opt_q(i, 6), opt_q(i, 7)]);
%     T = double(fkine);
%     trplot(T, 'rgb', 'length', 0.1, 'notext'); hold on;
%     title('最优激励轨迹示意图'); 
%     xlabel('x/m'); ylabel('y/m'); zlabel('z/m');
%     grid on;
% end

%% ANIMATION GIF OF EXCITATION TRAJECTORY
% last_fpos = zeros(3, 1);
% gap_pnts = zeros(3, 100);
% for i = 1:traj_n
%     q = [0, opt_q(i, 1), opt_q(i, 2), opt_q(i, 3), opt_q(i, 4), opt_q(i, 5), opt_q(i, 6), opt_q(i, 7)];
%     xm3p_modDH.plot(q); hold on;     % animation
%     fpos = xm3p_modDH.fkine(q);
% 
%     if i > 1
%         gap_pnts(1, :) = linspace(last_fpos(1), fpos.t(1), 100);
%         gap_pnts(2, :) = linspace(last_fpos(2), fpos.t(2), 100);
%         gap_pnts(3, :) = linspace(last_fpos(3), fpos.t(3), 100);
%         plot3(gap_pnts(1, :), gap_pnts(2, :), gap_pnts(3, :), 'r', 'LineWidth', 1.0);
%     else
%         plot3(fpos.t(1), fpos.t(2), fpos.t(3), 'r', 'LineWidth', 1.0);
%     end
% 
%     zlim([0.05, 1.5]);
%     xlim([-1, 1.5]);
%     ylim([-1, 1.5]);
%     title('激励轨迹仿真示意图');
%     last_fpos = [fpos.t(1), fpos.t(2), fpos.t(3)];
%     
%     % Capture the plot as an image 
%     F = getframe(gcf);
%     I = frame2im(F);
%     [I, map] = rgb2ind(I, 256);
% 
%     % Write to the GIF File 
%     if i == 1
%         imwrite(I, map, '.\figs\train\excit_traj_simulation.gif', 'gif', 'Loopcount', inf, 'DelayTime', 0.1);
%     else
%         imwrite(I, map, '.\figs\train\excit_traj_simulation.gif', 'gif', 'WriteMode', 'append', 'DelayTime', 0.1);
%     end
% end

%% REACHABLE SPACE
% lim_max = [170 120 170 120 170 120 360];
% lim_min = [-170 -120 -170 -120 -170 -120 -360];
% 
% sample_pnts = 3e6; 
% q_rand = zeros(sample_pnts, 7);
% for i = 1:7
%     q_rand(:, i) = (lim_min(i) + (lim_max(i)) * rand(sample_pnts, 1)) * pi / 180;
% end
% 
% fpos = xm3p_modDH.fkine(q_rand);
% x = zeros(sample_pnts, 1);
% y = zeros(sample_pnts, 1);
% z = zeros(sample_pnts, 1);
% for n = 1:1:sample_pnts
%     x(n) = fpos(n).t(1);
%     y(n) = fpos(n).t(2);
%     z(n) = fpos(n).t(3);
% end
% plot3(x, y, z, 'r.', 'MarkerSize', 1.0);

rmpath('.\utils\')
