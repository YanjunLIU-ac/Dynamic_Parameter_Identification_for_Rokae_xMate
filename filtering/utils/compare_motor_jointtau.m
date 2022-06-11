%% compare_motor_jointtau.m
% @brief: compare motor torque with joint torque

addpath('..');
% order of filter
n = 5;
% sampling frequency 
ws = 10;
% cut-off frequency
wc = 3;
% number of sampling points
pnt = 200;
% cut-off frequency
wn = wc / (ws / 2);
% low-pass filter
[b, a] = butter(n, wn, 'low');
% flags
is_downsample = 1;
is_filtering = 0;

% read data from file
t_raw = load('..\data\excit\excit_torque_record.txt');
m_raw = load('..\data\excit\excit_motor_record.txt');

% downsampling
[~, ~, ~, t_ds] = downsampling(t_raw, t_raw, t_raw, t_raw, pnt);
[~, ~, ~, m_ds] = downsampling(m_raw, m_raw, m_raw, m_raw, pnt);

if is_downsample
	t = t_ds;
	m = m_ds;
else
	t = t_raw;
	m = m_raw;
end

% zero-phase digital filtering
if is_filtering
	t = filtfilt(b, a, t); 
	m = filtfilt(b, a, m);
end

%% VISUALIZATION
for i = 1:7
	% figure(i);
	subplot(2, 4, i);
	plot(m(:, i), 'b', 'LineWidth', 0.5); hold on;
	plot(t(:, i), 'r', 'LineWidth', 0.5); 
    plot(m(:, i)-t(:, i), 'g', 'LineWidth', 0.5); hold off;
	title(['第', num2str(i), '关节力矩对比'], 'FontName', '宋体');
	ylabel('力矩(Nm)', 'FontName', '宋体');
	% legend('电机力矩', '关节力矩', 'FontName', '宋体');
end
% print(1, '-dpng', '-r600', ['joint', num2str(i), '_torque_comp.png']);

rmpath('..');