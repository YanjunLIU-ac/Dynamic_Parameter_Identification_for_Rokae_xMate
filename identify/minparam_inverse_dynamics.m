function T = minparam_inverse_dynamics(q, qd, qdd, mode)
% @brief: inverse dynamics to figure out joint torque by applying minimal parameter set
% @param[in] q, qd, qdd: joint position, velocity, acceleration (rad, rad/s, rad/s^2)
% @param[in] mode: str, 'math' or 'syms' 
% @param[out] T: joint torque (Nm)

W_min = evalin('base','W_min');
P_min = evalin('base','P_min');

%% PARAMETER
if mode == "syms"
    % sine and cosine function
    s1 = sin(q(1)); c1 = cos(q(1)); 
    s2 = sin(q(2)); c2 = cos(q(2));
    s3 = sin(q(3)); c3 = cos(q(3));
    s4 = sin(q(4)); c4 = cos(q(4));
    s5 = sin(q(5)); c5 = cos(q(5));
    s6 = sin(q(6)); c6 = cos(q(6));
    s7 = sin(q(7)); c7 = cos(q(7));
    % joint velocity and acceleration
    dQ1 = qd(1); ddQ1 = qdd(1);
    dQ2 = qd(2); ddQ2 = qdd(2);
    dQ3 = qd(3); ddQ3 = qdd(3);
    dQ4 = qd(4); ddQ4 = qdd(4); 
    dQ5 = qd(5); ddQ5 = qdd(5); 
    dQ6 = qd(6); ddQ6 = qdd(6);
    dQ7 = qd(7); ddQ7 = qdd(7);
    % DH and load parameters
    fe1 = 0; fe2 = 0; fe3 = 0; ne1 = 0; ne2 = 0; ne3 = 0;
    d1 = 341.5; d3 = 394.0; d5 = 366; d7 = 250.3; g = 9802; % in mm
    
    %% FORWARD
    W_mins = eval(subs(W_min,{'s1', 'c1', 's2', 'c2', 's3', 'c3', 's4', 'c4', 's5', 'c5', 's6', 'c6', 's7', 'c7', ...
                              'dQ1', 'dQ2', 'dQ3', 'dQ4', 'dQ5', 'dQ6', 'dQ7', ...
                              'ddQ1', 'ddQ2', 'ddQ3', 'ddQ4', 'ddQ5', 'ddQ6', 'ddQ7', ...
                              'fe1', 'fe2', 'fe3', 'ne1', 'ne2', 'ne3', ...
                              'g', 'd1', 'd3', 'd5', 'd7'},...
                              {s1, c1, s2, c2, s3, c3, s4, c4, s5, c5, s6, c6, s7, c7, ...
                              dQ1, dQ2, dQ3, dQ4, dQ5, dQ6, dQ7, ...
                              ddQ1, ddQ2, ddQ3, ddQ4, ddQ5, ddQ6, ddQ7, ...
                              fe1, fe2, fe3, ne1, ne2, ne3, ...
                              g, d1, d3, d5, d7}));
elseif mode == "math"
    W_mins = min_regressor(q, qd, qdd); 
end

T = W_mins * P_min; 

end

