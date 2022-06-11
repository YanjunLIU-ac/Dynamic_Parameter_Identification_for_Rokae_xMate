%% compute_model_error.m

% number of data points
n = linspace(1, 200, 200);

% first-order filter
sample_p = 0.001;
cutoff_f = 100;
a = 1 / (1 + 1 / (2 * pi * sample_p * cutoff_f));
b0 = 1 / (1 + (1 / (pi * sample_p * cutoff_f)));
b1 = b0;
a0 = -(1 - (1 / (pi * cutoff_f * sample_p))) / (1+(1/(pi * cutoff_f * sample_p)));

% single test
% q_test = [0, pi/6, 0, pi/3, 0, pi/2, 0];
% qd_test = [1.1, 0., -0.5, 0.75, -0.87, 1.09, 1.32];
% qdd_test = [2.01, 3.07, -3.12, -2.54, 1, 0.5, 0.98];
% t_single = NewtonEuler_iter(q_test, qd_test, qdd_test, "P_link");

% compute identified torque
T_idy = zeros(200, 7);
T_idy_filt = zeros(200, 7);
for kk = 1:200
    disp(['FIGURING OUT No.', num2str(kk), ' point!']);
    % computation method
    % T_idy(kk, :) = NewtonEuler_syms(q_ds(kk, :), qd_ds(kk, :), qdd_ds(kk, :));
    
    T_idy(kk, :) = NewtonEuler91(q_ds(kk, :), qd_ds(kk, :), qdd_ds(kk, :), "P_link");
    %% filtering
    if (kk > 1)
        T_idy_filt(kk, :) = b0 * T_idy(kk, :) + b1 * T_idy(kk-1, :) + a0 * T_idy_filt(kk-1, :);
    else
        T_idy_filt(1, :) = T_idy(1, :);
    end
end

% figure(1);
error = zeros(200, 7);
for ii = 1:7
    % figure(ii);
    subplot(2, 4, ii)
    % plot(n, t_ds(:, ii), 'b'); hold on;
    plot(n, t_filt(:, ii), 'b'); hold on;
    plot(n, T_idy(:, ii), 'r');
    plot(n, t_filt(:, ii) - T_idy(:, ii), 'g'); hold off;
    % legend('采样力矩', '辨识力矩', '相对误差', 'FontName', '宋体', 'FontSize', 12);
    ylabel('力矩(Nm)', 'FontSize', 17, 'FontName', '宋体');
    title(['第', num2str(ii), '关节力矩前馈误差'], 'FontSize', 17, 'FontName', '宋体');
    % print(ii, '-dpng', '-r600', ['.\figs\第', num2str(ii), '关节辨识参数验证'])
    error(:, ii) = abs(t_ds(:, ii) - T_idy(:, ii));
end

%% filtering result
% figure(2);
% for ii = 1:7
%     % figure(ii);
%     subplot(2, 4, ii)
%     plot(n, T_idy(:, ii), 'b'); hold on;
%     plot(n, T_idy_filt(:, ii), 'r'); hold off;
%     legend('辨识数据', '滤波数据', 'FontName', '宋体');
%     ylabel('力矩(Nm)');
%     title(['第', num2str(ii), '关节力矩前馈滤波结果']);
%     % print(ii, '-dpng', '-r600', ['.\figs\iters\第', num2str(ii), '关节误差(Plink_wm)'])
%     % error(:, ii) = abs(t_ds(:, ii) - T_idy(:, ii));
% end