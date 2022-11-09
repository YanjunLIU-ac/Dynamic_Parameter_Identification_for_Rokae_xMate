%% verify_identified_parameter.m
% @brief: compute feedforward torque using identified parameter and
%         compare the difference between feedforward and real torque.
% @dependency: minparam_inverse_dynamics.m (feedforward computation)
function verify_identified_parameter()

addpath('./utils');
%% PARAMETER
% filtered trajectory data
traj_Ts = evalin('base', 'traj_Ts');
t_filt = evalin('base', 't_filt');
q_filt = evalin('base', 'q_filt');
qd_filt = evalin('base', 'qd_filt');
qdd_filt = evalin('base', 'qdd_filt');

%% FEEDFORWARD
n = length(q_filt);		% number of sampling points
T = zeros(n, 7);
T_idy = zeros(n, 7);
for k = 1:1:n
	q = q_filt(k, :);
	qd = qd_filt(k, :);
	qdd = qdd_filt(k, :);
	
	T(k, :) = t_filt(k, :);
	T_idy(k,:) = minparam_inverse_dynamics(q, qd, qdd, "math")' * 1e-3;
end

%% VISUALIZATION
t = linspace(0, n-1, n) * traj_Ts;
for ii = 1:7
    figure(ii);
    plot(t, T(:, ii), 'b', 'LineWidth', 1.0); hold on;
    plot(t, T_idy(:, ii), 'r', 'LineWidth', 1.0);
    plot(t, T(:, ii) - T_idy(:, ii), 'g', 'LineWidth', 1.0); hold off;
    ylabel('力矩(Nm)');
    legend('采集力矩', '辨识力矩', '相对误差')
    title(['第', num2str(ii), '关节辨识参数验证'])
    print(ii, '-dpng', '-r600', ['.\figs\idy\idy', num2str(ii), '.png']);
end
for jj = 1:7
    figure(jj + 7);
    plot(t, T(:, jj) - T_idy(:, jj), 'g', 'LineWidth', 1.0);
    title(['第', num2str(jj), '关节辨识参数误差']);
    ylabel('力矩(Nm)')
    print(7 + jj, '-dpng', '-r600', ['.\figs\diff\diff', num2str(jj), '.png']);
end

error = zeros(7, 1);
figure(15)
for kk = 1:7
    plot(t, T(:, kk) - T_idy(:, kk), 'LineWidth', 1.0); hold on;
    error(kk) = sum((T(:, kk) - T_idy(:, kk)).^2);
end
ylabel('力矩(Nm)');
legend('关节1', '关节2', '关节3', '关节4', '关节5', '关节6', '关节7')
title('辨识力矩与采集力矩误差')
print(15, '-dpng', '-r600', '.\figs\holistic_diff.png');

disp('Identification error for 7 joints:');
disp(sqrt(error / 200));

close all;
rmpath('./utils');