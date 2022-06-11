function [ds_q, ds_qd, ds_qdd, ds_tau] = downsampling(raw_q, raw_qd, raw_qdd, raw_tau, down_size)
% @brief: downsample raw data from robot sensors
% @param[in] raw_q, raw_qd, raw_qdd, raw_tau:
%            raw joint angle, velocity, acceleration, torque data from sensors
% @param[in] down_size: downsampling size
% @param[out] ds_q, ds_qd, ds_qdd, ds_tau:
%             downsampled joint angle, velocity, acceleration, torque

% filtering
% uni_data = unique([raw_q, raw_qd, raw_qdd, raw_tau], 'rows');
% uni_q = uni_data(:, 1:7);
% uni_qd = uni_data(:, 8:14);
% uni_qdd = uni_data(:, 15:21);
% uni_tau = uni_data(:, 22:28);

ds_q = zeros(down_size, 7);
ds_qd = zeros(down_size, 7);
ds_qdd = zeros(down_size, 7);
ds_tau = zeros(down_size, 7);

% downsampling
step = fix(size(raw_q, 1) / down_size);
for i = 1:down_size
    ds_q(i, :) = raw_q(step * i, :);
    ds_qd(i, :) = raw_qd(step * i, :);
    ds_qdd(i, :) = raw_qdd(step * i, :);
    ds_tau(i, :) = raw_tau(step * i, :);
end

