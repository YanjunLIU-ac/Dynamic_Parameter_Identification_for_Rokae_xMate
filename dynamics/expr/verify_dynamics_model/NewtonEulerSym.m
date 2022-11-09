function T = NewtonEuler_syms(q, qd, qdd)

%% GENERAL PARAMETERS
s1 = sin(q(1)); c1 = cos(q(1)); 
s2 = sin(q(2)); c2 = cos(q(2));
s3 = sin(q(3)); c3 = cos(q(3));
s4 = sin(q(4)); c4 = cos(q(4));
s5 = sin(q(5)); c5 = cos(q(5));
s6 = sin(q(6)); c6 = cos(q(6));
s7 = sin(q(7)); c7 = cos(q(7));

dQ1 = qd(1); ddQ1 = qdd(1); 
dQ2 = qd(2); ddQ2 = qdd(2);
dQ3 = qd(3); ddQ3 = qdd(3); 
dQ4 = qd(4); ddQ4 = qdd(4);
dQ5 = qd(5); ddQ5 = qdd(5);
dQ6 = qd(6); ddQ6 = qdd(6);
dQ7 = qd(7); ddQ7 = qdd(7);

g = 9802.0; d1 = 341.5; d3 = 394.0; d5 = 366; d7 = 250.3; % in mm
fe1 = 0; fe2 = 0; fe3 = 0; ne1 = 0; ne2 = 0; ne3 = 0;

%% STANDARD SET BY P_link
P_link = evalin('base','P_link');
linkineTAU = evalin('base','linkineTAU');

m1 = P_link(1); 
m2 = P_link(14); 
m3 = P_link(27); 
m4 = P_link(40); 
m5 = P_link(53); 
m6 = P_link(66); 
m7 = P_link(79);

mc11 = P_link(2) /m1; mc12 = P_link(3) /m1; mc13 = P_link(4) /m1;
mc21 = P_link(15)/m2; mc22 = P_link(16)/m2; mc23 = P_link(17)/m2;
mc31 = P_link(28)/m3; mc32 = P_link(29)/m3; mc33 = P_link(30)/m3;
mc41 = P_link(41)/m4; mc42 = P_link(42)/m4; mc43 = P_link(43)/m4;
mc51 = P_link(54)/m5; mc52 = P_link(55)/m5; mc53 = P_link(56)/m5;
mc61 = P_link(67)/m6; mc62 = P_link(68)/m6; mc63 = P_link(69)/m6;
mc71 = P_link(80)/m7; mc72 = P_link(81)/m7; mc73 = P_link(82)/m7;

Io111 = P_link(5) ; Io122 = P_link(6) ; Io133 = P_link(7) ; Io112 = P_link(8) ; Io113 = P_link(9) ; Io123 = P_link(10);
Io211 = P_link(18); Io222 = P_link(19); Io233 = P_link(20); Io212 = P_link(21); Io213 = P_link(22); Io223 = P_link(23);
Io311 = P_link(31); Io322 = P_link(32); Io333 = P_link(33); Io312 = P_link(34); Io313 = P_link(35); Io323 = P_link(36);
Io411 = P_link(44); Io422 = P_link(45); Io433 = P_link(46); Io412 = P_link(47); Io413 = P_link(48); Io423 = P_link(49);
Io511 = P_link(57); Io522 = P_link(58); Io533 = P_link(59); Io512 = P_link(60); Io513 = P_link(61); Io523 = P_link(62);
Io611 = P_link(70); Io622 = P_link(71); Io633 = P_link(72); Io612 = P_link(73); Io613 = P_link(74); Io623 = P_link(75);
Io711 = P_link(83); Io722 = P_link(84); Io733 = P_link(85); Io712 = P_link(86); Io713 = P_link(87); Io723 = P_link(88);

Ia1 = P_link(11);
Ia2 = P_link(24);
Ia3 = P_link(37);
Ia4 = P_link(50);
Ia5 = P_link(63);
Ia6 = P_link(76);
Ia7 = P_link(89);

fv1 = P_link(12); fc1 = P_link(13); 
fv2 = P_link(25); fc2 = P_link(26); 
fv3 = P_link(38); fc3 = P_link(39); 
fv4 = P_link(51); fc4 = P_link(52); 
fv5 = P_link(64); fc5 = P_link(65); 
fv6 = P_link(77); fc6 = P_link(78); 
fv7 = P_link(90); fc7 = P_link(91); 

T = eval(subs(linkineTAU, ...
             {'m1', 'mc11', 'mc12', 'mc13', 'Io111', 'Io122', 'Io133', 'Io112', 'Io113', 'Io123', 'Ia1', 'fv1', 'fc1', ...
              'm2', 'mc21', 'mc22', 'mc23', 'Io211', 'Io222', 'Io233', 'Io212', 'Io213', 'Io223', 'Ia2', 'fv2', 'fc2', ...
              'm3', 'mc31', 'mc32', 'mc33', 'Io311', 'Io322', 'Io333', 'Io312', 'Io313', 'Io323', 'Ia3', 'fv3', 'fc3', ...
              'm4', 'mc41', 'mc42', 'mc43', 'Io411', 'Io422', 'Io433', 'Io412', 'Io413', 'Io423', 'Ia4', 'fv4', 'fc4', ...
              'm5', 'mc51', 'mc52', 'mc53', 'Io511', 'Io522', 'Io533', 'Io512', 'Io513', 'Io523', 'Ia5', 'fv5', 'fc5', ...
              'm6', 'mc61', 'mc62', 'mc63', 'Io611', 'Io622', 'Io633', 'Io612', 'Io613', 'Io623', 'Ia6', 'fv6', 'fc6', ...
              'm7', 'mc71', 'mc72', 'mc73', 'Io711', 'Io722', 'Io733', 'Io712', 'Io713', 'Io723', 'Ia7', 'fv7', 'fc7', ...
              's1', 'c1', 's2', 'c2', 's3', 'c3', 's4', 'c4', 's5', 'c5', 's6', 'c6', 's7', 'c7', ...
              'dQ1', 'dQ2', 'dQ3', 'dQ4', 'dQ5', 'dQ6', 'dQ7', ...
              'ddQ1', 'ddQ2', 'ddQ3', 'ddQ4', 'ddQ5', 'ddQ6', 'ddQ7', ...
              'fe1', 'fe2', 'fe3',  'ne1', 'ne2', 'ne3', ...
              'g', 'd1', 'd3', 'd5', 'd7'}, ...
             {m1, mc11, mc12, mc13, Io111, Io122, Io133, Io112, Io113, Io123, Ia1, fv1, fc1, ...
              m2, mc21, mc22, mc23, Io211, Io222, Io233, Io212, Io213, Io223, Ia2, fv2, fc2, ...
              m3, mc31, mc32, mc33, Io311, Io322, Io333, Io312, Io313, Io323, Ia3, fv3, fc3, ...
              m4, mc41, mc42, mc43, Io411, Io422, Io433, Io412, Io413, Io423, Ia4, fv4, fc4, ...
              m5, mc51, mc52, mc53, Io511, Io522, Io533, Io512, Io513, Io523, Ia5, fv5, fc5, ...
              m6, mc61, mc62, mc63, Io611, Io622, Io633, Io612, Io613, Io623, Ia6, fv6, fc6, ...
              m7, mc71, mc72, mc73, Io711, Io722, Io733, Io712, Io713, Io723, Ia7, fv7, fc7, ...
              s1, c1, s2, c2, s3, c3, s4, c4, s5, c5, s6, c6, s7, c7, ...
              dQ1, dQ2, dQ3, dQ4, dQ5, dQ6, dQ7, ...
              ddQ1, ddQ2, ddQ3, ddQ4, ddQ5, ddQ6, ddQ7, ...
              fe1, fe2, fe3, ne1, ne2, ne3, ...
              g, d1, d3, d5, d7}));

%% STANDARD SET BY P_link
TAU = evalin('base','TAU');
P_center = evalin('base','P_center');

m1 = P_center(1); 
m2 = P_center(14); 
m3 = P_center(27); 
m4 = P_center(40); 
m5 = P_center(53); 
m6 = P_center(66); 
m7 = P_center(79);

mc11 = P_center(2) /m1; mc12 = P_center(3) /m1; mc13 = P_center(4) /m1;
mc21 = P_center(15)/m2; mc22 = P_center(16)/m2; mc23 = P_center(17)/m2;
mc31 = P_center(28)/m3; mc32 = P_center(29)/m3; mc33 = P_center(30)/m3;
mc41 = P_center(41)/m4; mc42 = P_center(42)/m4; mc43 = P_center(43)/m4;
mc51 = P_center(54)/m5; mc52 = P_center(55)/m5; mc53 = P_center(56)/m5;
mc61 = P_center(67)/m6; mc62 = P_center(68)/m6; mc63 = P_center(69)/m6;
mc71 = P_center(80)/m7; mc72 = P_center(81)/m7; mc73 = P_center(82)/m7;

Io111 = P_center(5) ; Io122 = P_center(6) ; Io133 = P_center(7) ; Io112 = P_center(8) ; Io113 = P_center(9) ; Io123 = P_center(10);
Io211 = P_center(18); Io222 = P_center(19); Io233 = P_center(20); Io212 = P_center(21); Io213 = P_center(22); Io223 = P_center(23);
Io311 = P_center(31); Io322 = P_center(32); Io333 = P_center(33); Io312 = P_center(34); Io313 = P_center(35); Io323 = P_center(36);
Io411 = P_center(44); Io422 = P_center(45); Io433 = P_center(46); Io412 = P_center(47); Io413 = P_center(48); Io423 = P_center(49);
Io511 = P_center(57); Io522 = P_center(58); Io533 = P_center(59); Io512 = P_center(60); Io513 = P_center(61); Io523 = P_center(62);
Io611 = P_center(70); Io622 = P_center(71); Io633 = P_center(72); Io612 = P_center(73); Io613 = P_center(74); Io623 = P_center(75);
Io711 = P_center(83); Io722 = P_center(84); Io733 = P_center(85); Io712 = P_center(86); Io713 = P_center(87); Io723 = P_center(88);

Ia1 = P_center(11);
Ia2 = P_center(24);
Ia3 = P_center(37);
Ia4 = P_center(50);
Ia5 = P_center(63);
Ia6 = P_center(76);
Ia7 = P_center(89);

fv1 = P_center(12); fc1 = P_center(13); 
fv2 = P_center(25); fc2 = P_center(26); 
fv3 = P_center(38); fc3 = P_center(39); 
fv4 = P_center(51); fc4 = P_center(52); 
fv5 = P_center(64); fc5 = P_center(65); 
fv6 = P_center(77); fc6 = P_center(78); 
fv7 = P_center(90); fc7 = P_center(91); 

T = eval(subs(TAU, ...
             {'m1', 'mc11', 'mc12', 'mc13', 'Ic111', 'Ic122', 'Ic133', 'Ic112', 'Ic113', 'Ic123', 'Ia1', 'fv1', 'fc1', ...
              'm2', 'mc21', 'mc22', 'mc23', 'Ic211', 'Ic222', 'Ic233', 'Ic212', 'Ic213', 'Ic223', 'Ia2', 'fv2', 'fc2', ...
              'm3', 'mc31', 'mc32', 'mc33', 'Ic311', 'Ic322', 'Ic333', 'Ic312', 'Ic313', 'Ic323', 'Ia3', 'fv3', 'fc3', ...
              'm4', 'mc41', 'mc42', 'mc43', 'Ic411', 'Ic422', 'Ic433', 'Ic412', 'Ic413', 'Ic423', 'Ia4', 'fv4', 'fc4', ...
              'm5', 'mc51', 'mc52', 'mc53', 'Ic511', 'Ic522', 'Ic533', 'Ic512', 'Ic513', 'Ic523', 'Ia5', 'fv5', 'fc5', ...
              'm6', 'mc61', 'mc62', 'mc63', 'Ic611', 'Ic622', 'Ic633', 'Ic612', 'Ic613', 'Ic623', 'Ia6', 'fv6', 'fc6', ...
              'm7', 'mc71', 'mc72', 'mc73', 'Ic711', 'Ic722', 'Ic733', 'Ic712', 'Ic713', 'Ic723', 'Ia7', 'fv7', 'fc7', ...
              's1', 'c1', 's2', 'c2', 's3', 'c3', 's4', 'c4', 's5', 'c5', 's6', 'c6', 's7', 'c7', ...
              'dQ1', 'dQ2', 'dQ3', 'dQ4', 'dQ5', 'dQ6', 'dQ7', ...
              'ddQ1', 'ddQ2', 'ddQ3', 'ddQ4', 'ddQ5', 'ddQ6', 'ddQ7', ...
              'fe1', 'fe2', 'fe3',  'ne1', 'ne2', 'ne3', ...
              'g', 'd1', 'd3', 'd5', 'd7'}, ...
             {m1, mc11, mc12, mc13, Ic111, Ic122, Ic133, Ic112, Ic113, Ic123, Ia1, fv1, fc1, ...
              m2, mc21, mc22, mc23, Ic211, Ic222, Ic233, Ic212, Ic213, Ic223, Ia2, fv2, fc2, ...
              m3, mc31, mc32, mc33, Ic311, Ic322, Ic333, Ic312, Ic313, Ic323, Ia3, fv3, fc3, ...
              m4, mc41, mc42, mc43, Ic411, Ic422, Ic433, Ic412, Ic413, Ic423, Ia4, fv4, fc4, ...
              m5, mc51, mc52, mc53, Ic511, Ic522, Ic533, Ic512, Ic513, Ic523, Ia5, fv5, fc5, ...
              m6, mc61, mc62, mc63, Ic611, Ic622, Ic633, Ic612, Ic613, Ic623, Ia6, fv6, fc6, ...
              m7, mc71, mc72, mc73, Ic711, Ic722, Ic733, Ic712, Ic713, Ic723, Ia7, fv7, fc7, ...
              s1, c1, s2, c2, s3, c3, s4, c4, s5, c5, s6, c6, s7, c7, ...
              dQ1, dQ2, dQ3, dQ4, dQ5, dQ6, dQ7, ...
              ddQ1, ddQ2, ddQ3, ddQ4, ddQ5, ddQ6, ddQ7, ...
              fe1, fe2, fe3, ne1, ne2, ne3, ...
              g, d1, d3, d5, d7}));
			
%% SCALING
T = 1e-3 * T;

end

