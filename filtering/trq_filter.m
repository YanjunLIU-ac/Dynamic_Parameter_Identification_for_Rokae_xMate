function t_filt = trq_filter(n, ws, wc, t_raw, path_prefix)
%% torque_filter.m
% @brief: offline zero-phase butterworth filtering for torque
% @params[in] n: order of filter (5 by default)
% @params[in] ws: sampling frequency (10 by default)
% @params[in] wc: cut-off frequency (3 by default)
% @params[in] t_raw: raw joint torque data from sensors
% @params[out] t_filt: filtered joint torque data

% cut-off frequency
wn = wc / (ws / 2);		
% low-pass filter
[b, a] = butter(n, wn, 'low');
% zero-phase digital filtering
t_filt = filtfilt(b, a, t_raw);
% t_filt = smooth(t_raw, 6, 'rloess');
% t_filt = smooth(t_filt, 6, 'rloess');

%% VISUALIZATION
for i = 1:7
	figure(i + 21); 
	plot(t_raw(:, i), 'g', 'LineWidth', 1.0); hold on;
	plot(t_filt(:, i), 'r', 'LineWidth', 0.5); hold off;
	title(['第', num2str(i), '关节力矩滤波结果'], 'FontSize', 17, 'FontName', '宋体');
	ylabel('关节力矩(Nm)', 'FontSize', 17, 'FontName', '宋体');
	legend('滤波前', '滤波后', 'FontSize', 12, 'FontName', '宋体');
    print(i + 21, '-dpng', '-r600', [path_prefix, 'Joint', num2str(i), 'Torque.png']);
end

end



