function [q, qd, qdd] = traj_func(traj_param, dof, time, traj_wf, traj_order)
% @brief: generate trajectory based on Fourier-series,
%         for each joint, there should be q0 (only one), alpha (#order), beta (#order)
%         which is #(1+2*traj_order) parameters in total
%         (refer to `Study on Parameter Indentification for Rokae XB4`)
% @param[in] traj_param: hyper-parameter matrix (q_{0}, alpha and beta)
%            e.g. for Joint 1 with traj_order being 5,
%                 traj_param([1, 3, 5, 7, 9]) denotes coeff for sine: alpha
%                 traj_param([2, 4, 6, 8, 10]) denotes coeff for cosine: beta
%                 traj_param(11) denotes initial joint angle: q0
% @param[in] dof: number of revolute joints
% @param[in] time: time elapse (#sampling points * period)
% @param[in] traj_wf: trajectory fundamental frequency in radian
% @param[in] traj_order: order of trajectory generation (5 by default)
% @param[out] q: joint angle
% @param[out] qd: joint velocity
% @param[out] qdd: joint acceleration

q = zeros(dof, 1);
qd = zeros(dof, 1);
qdd = zeros(dof, 1);
order_prod_2 = traj_order * 2;

for ii = 1:dof
   m = (order_prod_2 + 1) * (ii - 1); 
   q(ii) = traj_param(m + order_prod_2 + 1);
   for jj = 1:traj_order
       % alpha=traj_param(m+2*(jj-1)+1), beta=traj_param(m+2*(jj-1)+2)
       q(ii) = q(ii) + ( ...
               (traj_param(m + 2*(jj-1) + 1) / (traj_wf * jj)) * sin(traj_wf * jj * time) - ...
               (traj_param(m + 2*(jj-1) + 2) / (traj_wf * jj)) * cos(traj_wf * jj * time));
       qd(ii) = qd(ii) + ( ...
	            traj_param(m + 2*(jj-1) + 1) * cos(traj_wf * jj * time) + ...
			    traj_param(m + 2*(jj-1) + 2) * sin(traj_wf * jj * time));
       qdd(ii) = qdd(ii) + traj_wf* jj * ( ...
	             -traj_param(m + 2*(jj-1) + 1) * sin(traj_wf * jj * time) + ...
				 traj_param(m + 2*(jj-1) + 2) * cos(traj_wf * jj * time));
   end    
end

end

