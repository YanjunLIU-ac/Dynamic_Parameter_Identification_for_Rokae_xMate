function qdd_filt = acc_filter(n, ws, wc, input, mode, path_prefix)
%% acc_filtering.m
% @brief: offline zero-phase butterworth filtering for qdd (joint acceleration)
% @params[in] n: order of filter (5 by default)
% @params[in] ws: sampling frequency (10 by default)
% @params[in] wc: cut-off frequency (3 by default)
% @params[in] input: qdd_raw for sensor reading, qd_filt for derivative
% @params[in] mode: "sensor" or "derivate"
% @params[out] qdd_filtered: filtered joint acceleration data

% cut-off frequency
wn = wc / (ws / 2);		
% low-pass filter
[b, a] = butter(n, wn, 'low');
% sampling period  
Ts = 1 / ws;    

%% FILTERING
if mode == "derivate"
	len = length(input(:, 1));	 % input is qd_filt and length is 200
	qdd_pre_filt = zeros(len, 7);

	for k = 2:len-1
		qdd_pre_filt(k, :)= (input(k+1,:) - input(k-1,:)) / (2 * Ts);
	end
	qdd_pre_filt(1, :) = qdd_pre_filt(2, :);
	qdd_pre_filt(len, :) = qdd_pre_filt(len-1, :);
elseif mode == "sensor"
	qdd_pre_filt = input;  % input is qd_raw
end
qdd_filt = filtfilt(b, a, qdd_pre_filt);
% qdd_filt = smooth(qdd_pre_filt, 'rloess');

%% VISUALIZATION
for i = 1:7
	figure(i + 14); 
	plot(qdd_pre_filt(:,i), 'g', 'LineWidth', 1.0); hold on;
	plot(qdd_filt(:, i), 'r', 'LineWidth', 0.5); hold off;
	title(['第', num2str(i), '关节加速度滤波结果'], 'FontSize', 17, 'FontName', '宋体');
	ylabel('关节加速度(rad/s^{2})', 'FontSize', 17, 'FontName', '宋体');
	legend('滤波前', '滤波后', 'FontName', '宋体', 'FontSize', 12);
    print(i + 14, '-dpng', '-r600', [path_prefix, 'Joint', num2str(i), 'Acc.png'])
end

end
