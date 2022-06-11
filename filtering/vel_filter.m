function qd_filt = vel_filter(n, ws, wc, input, mode, path_prefix)
%% vel_filter.m
% @brief: offline zero-phase butterworth filtering for qd (joint angle)
% @params[in] n: order of filter (5 by default)
% @params[in] ws: sampling frequency (10 by default)
% @params[in] wc: cut-off frequency (3 by default)
% @params[in] input: qd_raw for sensor reading, q_filt for derivative
% @params[in] mode: "sensor" or "derivate"
% @params[out] qd_filt: filtered joint angle data

% cut-off frequency
wn = wc / (ws / 2);		
% low-pass filter
[b, a] = butter(n, wn, 'low');
% sampling period
Ts = 1 / ws;    

%% FILTERING
if mode == "derivate"
	len = length(input(:, 1));    % input is q_filt and length is 200
	qd_pre_filt = zeros(len, 7);

	for k = 2:len-1
		qd_pre_filt(k, :) = (input(k+1,:) - input(k-1,:)) / (2 * Ts);	% derivative (bi-lateral)
	end
	qd_pre_filt(1, :) = qd_pre_filt(2, :);
	qd_pre_filt(len, :) = qd_pre_filt(len-1, :);
elseif mode == "sensor"
	qd_pre_filt = input;  % input is qd_raw
end
% zero-phase digital filtering
qd_filt = filtfilt(b, a, qd_pre_filt);	

%% VISUALIZATION
for i = 1:7
	figure(i + 7); 
	plot(qd_pre_filt(:, i), 'g', 'LineWidth', 1.0); hold on;
	plot(qd_filt(:, i), 'r', 'LineWidth', 0.5); hold off;
	title(['第', num2str(i), '关节速度滤波结果'], 'FontSize', 17, 'FontName', '宋体');
	ylabel('关节速度(rad/s)', 'FontSize', 17, 'FontName', '宋体');
	legend('滤波前', '滤波后', 'FontSize', 12, 'FontName', '宋体');
    print(i + 7, '-dpng', '-r600', [path_prefix, 'Joint', num2str(i), 'Vel.png']);
end

end

