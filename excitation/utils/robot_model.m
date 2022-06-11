%% STANDARD DH
% LB = Link([0, 0, 0, 0], 'standard');   % fixed
% L1 = Link([0, 0.3415, 0, -pi/2], 'standard');
% L2 = Link([0, 0, 0, pi/2], 'standard');
% L3 = Link([0, 0.394, 0, -pi/2], 'standard');
% L4 = Link([0, 0, 0, pi/2], 'standard');
% L5 = Link([0, 0.366, 0, -pi/2], 'standard');
% L6 = Link([0, 0, 0, pi/2], 'standard');
% L7 = Link([0, 0.2503, 0, 0], 'standard');
% L1.qlim = [-170, 170] * pi / 180;
% L2.qlim = [-120, 120] * pi / 180;
% L3.qlim = [-170, 170] * pi / 180;
% L4.qlim = [-120, 120] * pi / 180;
% L5.qlim = [-170, 170] * pi / 180;
% L6.qlim = [-120, 120] * pi / 180;
% xm3p_stdDH = SerialLink([LB, L1, L2, L3, L4, L5, L6, L7]);
% xm3p_stdDH.name = 'xMate3Pro-SDH';
% xm3p_stdDH.display();
% xm3p_stdDH.plot([0, 0, 0, 0, 0, 0, 0, 0]);
% xm3p_stdDH.teach();

%% MODIFIED DH: theta, d, a, alpha
LB = Link([0, 0, 0, 0], 'modified');   % fixed
L1 = Link([0, 0.3415, 0, 0], 'modified');
L2 = Link([0, 0, 0, -pi/2], 'modified');
L3 = Link([0, 0.394, 0, pi/2], 'modified');
L4 = Link([0, 0, 0, -pi/2], 'modified');
L5 = Link([0, 0.366, 0, pi/2], 'modified');
L6 = Link([0, 0, 0, -pi/2], 'modified');
L7 = Link([0, 0.2503, 0, pi/2], 'modified');
L1.qlim = [-170, 170] * pi / 180;
L2.qlim = [-120, 120] * pi / 180;
L3.qlim = [-170, 170] * pi / 180;
L4.qlim = [-120, 120] * pi / 180;
L5.qlim = [-170, 170] * pi / 180;
L6.qlim = [-120, 120] * pi / 180;
xm3p_modDH = SerialLink([LB, L1, L2, L3, L4, L5, L6, L7]);
xm3p_modDH.name = 'xMate3Pro-MDH';
xm3p_modDH.display();
xm3p_modDH.plot([0, 0, 0, 0, 0, 0, 0, 0]);
xm3p_modDH.teach();
