%% fourier_traj.m
% @brief: compute trajectory based on Fourier-series for references

PI = 3.1415926535;
PERIOD = 0.001;
CNT_PNTS = 20000;
RAD_FREQ = 0.3141592653;

load('.\data\opt_x_wo_geoconstraints.mat');
coeffs = reshape(opt_x, 11, 7)';

setpoints = zeros(CNT_PNTS + 1, 7);
for cnt = 0:1:CNT_PNTS
	rad_t = cnt * PERIOD * RAD_FREQ;
	fourier = [sin(rad_t * 1) / (RAD_FREQ * 1), -cos(rad_t * 1) / (RAD_FREQ * 1), ...
			   sin(rad_t * 2) / (RAD_FREQ * 2), -cos(rad_t * 2) / (RAD_FREQ * 2), ...
			   sin(rad_t * 3) / (RAD_FREQ * 3), -cos(rad_t * 3) / (RAD_FREQ * 3), ...
			   sin(rad_t * 4) / (RAD_FREQ * 4), -cos(rad_t * 4) / (RAD_FREQ * 4), ...
			   sin(rad_t * 5) / (RAD_FREQ * 5), -cos(rad_t * 5) / (RAD_FREQ * 5), 1]';
	setpoints(cnt + 1, :) = 0.3 * coeffs * fourier;
end