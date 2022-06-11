function T = NewtonEuler91(q, qd, qdd, mode)

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

g = 9.802; d1 = 0.3415; d3 = 0.3940; d5 = 0.366; d7 = 0.2503; % in m
fe1 = 0; fe2 = 0; fe3 = 0; ne1 = 0; ne2 = 0; ne3 = 0;

%% STANDARD SET BY P_link
if (mode == "P_link")
P_link = evalin('base', 'P_link');

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
elseif (mode == "P_center")
%% STANDARD SET BY P_center
P_center = evalin('base', 'P_center');

m1 = P_center(1); 
m2 = P_center(14); 
m3 = P_center(27); 
m4 = P_center(40); 
m5 = P_center(53); 
m6 = P_center(66); 
m7 = P_center(79);

mc11 = P_center(2) ; mc12 = P_center(3) ; mc13 = P_center(4) ;
mc21 = P_center(15); mc22 = P_center(16); mc23 = P_center(17);
mc31 = P_center(28); mc32 = P_center(29); mc33 = P_center(30);
mc41 = P_center(41); mc42 = P_center(42); mc43 = P_center(43);
mc51 = P_center(54); mc52 = P_center(55); mc53 = P_center(56);
mc61 = P_center(67); mc62 = P_center(68); mc63 = P_center(69);
mc71 = P_center(80); mc72 = P_center(81); mc73 = P_center(82);

Ic111 = P_center(5) ; Ic122 = P_center(6) ; Ic133 = P_center(7) ; Ic112 = P_center(8) ; Ic113 = P_center(9) ; Ic123 = P_center(10);
Ic211 = P_center(18); Ic222 = P_center(19); Ic233 = P_center(20); Ic212 = P_center(21); Ic213 = P_center(22); Ic223 = P_center(23);
Ic311 = P_center(31); Ic322 = P_center(32); Ic333 = P_center(33); Ic312 = P_center(34); Ic313 = P_center(35); Ic323 = P_center(36);
Ic411 = P_center(44); Ic422 = P_center(45); Ic433 = P_center(46); Ic412 = P_center(47); Ic413 = P_center(48); Ic423 = P_center(49);
Ic511 = P_center(57); Ic522 = P_center(58); Ic533 = P_center(59); Ic512 = P_center(60); Ic513 = P_center(61); Ic523 = P_center(62);
Ic611 = P_center(70); Ic622 = P_center(71); Ic633 = P_center(72); Ic612 = P_center(73); Ic613 = P_center(74); Ic623 = P_center(75);
Ic711 = P_center(83); Ic722 = P_center(84); Ic733 = P_center(85); Ic712 = P_center(86); Ic713 = P_center(87); Ic723 = P_center(88);

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
end
disp("<INFO> PARAMETERS Loaded!!");

%% VECTORIZATION
% rotation matrix, a = [0, -pi/2, pi/2, -pi/2, pi/2, -pi/2, pi/2];
%   R01: frame{1} relative to frame{0}
%   R10: frame{0} relative to frame{1}
R01 = [c1 -s1 0;
       s1 c1 0;
	   0 0 1];
R12 = [c2 -s2 0;
       0 0 1;
	   -s2 -c2 0];
R23 = [c3 -s3 0;
       0 0 -1;
	   s3 c3 0];
R34 = [c4 -s4 0;
       0 0 1;
	   -s4 -c4 0];
R45 = [c5 -s5 0;
       0 0 -1;
	   s5 c5 0];
R56 = [c6 -s6 0;
       0 0 1;
	   -s6 -c6 0];
R67 = [c7 -s7 0;
       0 0 -1;
	   s7 c7 0];   
R07 = R01 * R12 * R23 * R34 * R45 * R56 * R67;
R10 = R01'; R21 = R12'; R32 = R23'; R43 = R34';
R54 = R45'; R65 = R56'; R76 = R67'; %R7e = eye(3);
% joint velocity
dQZ1 = [0; 0; dQ1];
dQZ2 = [0; 0; dQ2];
dQZ3 = [0; 0; dQ3];
dQZ4 = [0; 0; dQ4];
dQZ5 = [0; 0; dQ5];
dQZ6 = [0; 0; dQ6];
dQZ7 = [0; 0; dQ7];
% joint acceleration
ddQZ1 = [0; 0; ddQ1];
ddQZ2 = [0; 0; ddQ2];
ddQZ3 = [0; 0; ddQ3];
ddQZ4 = [0; 0; ddQ4];
ddQZ5 = [0; 0; ddQ5];
ddQZ6 = [0; 0; ddQ6];
ddQZ7 = [0; 0; ddQ7];
% coordinate of next origin(frame) w.r.t. current origin(frame)
% DEBUG: POINT 2
P01 = [0; 0; d1];
P12 = [0; 0; 0];
P23 = [0; -d3; 0];
P34 = [0; 0; 0];
P45 = [0; -d5; 0];
P56 = [0; 0; 0];
P67 = [0; -d7; 0];
P7e = [0; 0; 0];
% position of CoM of link
Pc1 = [mc11; mc12; mc13];
Pc2 = [mc21; mc22; mc23];
Pc3 = [mc31; mc32; mc33];
Pc4 = [mc41; mc42; mc43];
Pc5 = [mc51; mc52; mc53];
Pc6 = [mc61; mc62; mc63]; 
Pc7 = [mc71; mc72; mc73];

% inertia matrix w.r.t. CoM
if (mode == "P_center")
Ic1 = [Ic111 Ic112 Ic113; Ic112 Ic122 Ic123; Ic113 Ic123 Ic133]; 
Ic2 = [Ic211 Ic212 Ic213; Ic212 Ic222 Ic223; Ic213 Ic223 Ic233]; 
Ic3 = [Ic311 Ic312 Ic313; Ic312 Ic322 Ic323; Ic313 Ic323 Ic333]; 
Ic4 = [Ic411 Ic412 Ic413; Ic412 Ic422 Ic423; Ic413 Ic423 Ic433]; 
Ic5 = [Ic511 Ic512 Ic513; Ic512 Ic522 Ic523; Ic513 Ic523 Ic533];
Ic6 = [Ic611 Ic612 Ic613; Ic612 Ic622 Ic623; Ic613 Ic623 Ic633]; 
Ic7 = [Ic711 Ic712 Ic713; Ic712 Ic722 Ic723; Ic713 Ic723 Ic733]; 
elseif (mode == "P_link")
% inertia matrix w.r.t. CoM
I = eye(3);
Io1 = [Io111 Io112 Io113; Io112 Io122 Io123; Io113 Io123 Io133]; 
Io2 = [Io211 Io212 Io213; Io212 Io222 Io223; Io213 Io223 Io233]; 
Io3 = [Io311 Io312 Io313; Io312 Io322 Io323; Io313 Io323 Io333]; 
Io4 = [Io411 Io412 Io413; Io412 Io422 Io423; Io413 Io423 Io433]; 
Io5 = [Io511 Io512 Io513; Io512 Io522 Io523; Io513 Io523 Io533];
Io6 = [Io611 Io612 Io613; Io612 Io622 Io623; Io613 Io623 Io633]; 
Io7 = [Io711 Io712 Io713; Io712 Io722 Io723; Io713 Io723 Io733]; 
Ic1 = Io1 - m1 * (Pc1' * Pc1 * I - Pc1 * Pc1');
Ic2 = Io2 - m2 * (Pc2' * Pc2 * I - Pc2 * Pc2');
Ic3 = Io3 - m3 * (Pc3' * Pc3 * I - Pc3 * Pc3');
Ic4 = Io4 - m4 * (Pc4' * Pc4 * I - Pc4 * Pc4');
Ic5 = Io5 - m5 * (Pc5' * Pc5 * I - Pc5 * Pc5');
Ic6 = Io6 - m6 * (Pc6' * Pc6 * I - Pc6 * Pc6');
Ic7 = Io7 - m7 * (Pc7' * Pc7 * I - Pc7 * Pc7');
end
% external force/torque acting on ee
fe = [fe1; fe2; fe3]; ne = [ne1; ne2; ne3];
disp("<INFO> VECTORIZATION complete!!");

%% ITERATIVE NETWON-EULER DYNAMIC FORMULATION
% using Craig's notation: 
%   wn = link 'n' velocity (\omega)
% 	dwn = link 'n' acceleration(\alpha)
% 	dvn = link 'n' acceleration (\a)
%   dvcn = link 'n' acceleration of the center of mass (\a_c)
%   Fn = link 'n' force acting on the center of the mass
%   Nn = link 'n' torque acting on the center of the mass 
w0 = [0;0;0];	% joint velocity of frame{base}
dw0 = [0;0;0];	% joint acceleration of frame{base}
dv0 = [0;0;g];	% linear acceleration of frame{base} (take gravity into consideration)

% outward ITERATION to compute velocities and accelerations
w1 = R10 * w0 + dQZ1;
dw1 = R10 * dw0 + cross(R10*w0, dQZ1) + ddQZ1;
dv1 = R10 * (cross(w0, P01) + cross(w0, cross(w0, P01)) + dv0);
dvc1 = cross(dw1, Pc1) + cross(w1, w1+Pc1) + dv1;
F1 = m1 * dvc1;
N1 = Ic1 * dw1 + cross(w1, Ic1*w1);
disp("<INFO> J1 outward ITERATION complete.");

w2 = R21 * w1 + dQZ2;
dw2 = R21 * dw1 + cross(R21*w1, dQZ2) + ddQZ2;
dv2 = R21 * (cross(w1, P12) + cross(w1, cross(w1, P12)) + dv1);
dvc2 = cross(dw2, Pc2) + cross(w2, w2+Pc2) + dv2;
F2 = m2 * dvc2;
N2 = Ic2 * dw2 + cross(w2, Ic2*w2);
disp("<INFO> J2 outward ITERATION complete.");

w3 = R32 * w2 + dQZ3;
dw3 = R32 * dw2 + cross(R32*w2, dQZ3) + ddQZ3;
dv3 = R32 * (cross(w2, P23) + cross(w2, cross(w2, P23)) + dv2);
dvc3 = cross(dw3, Pc3) + cross(w3, w3+Pc3) + dv3;
F3 = m3 * dvc3;
N3 = Ic3 * dw3 + cross(w3, Ic3*w3);
disp("<INFO> J3 outward ITERATION complete.");

w4 = R43 * w3 + dQZ4;
dw4 = R43 * dw3 + cross(R43*w3, dQZ4) + ddQZ4;
dv4 = R43 * (cross(w3, P34) + cross(w3, cross(w3, P34)) + dv3);
dvc4 = cross(dw4, Pc4) + cross(w4, w4+Pc4) + dv4;
F4 = m4 * dvc4;
N4 = Ic4 * dw4 + cross(w4, Ic4*w4);
disp("<INFO> J4 outward ITERATION complete.");

w5 = R54 * w4 + dQZ5;
dw5 = R54 * dw4 + cross(R54*w4, dQZ5) + ddQZ5;
dv5 = R54 * (cross(w4, P45) + cross(w4, cross(w4, P45)) + dv4);
dvc5 = cross(dw5, Pc5) + cross(w5, w5+Pc5) + dv5;
F5 = m5 * dvc5;
N5 = Ic5 * dw5 + cross(w5, Ic5*w5);
disp("<INFO> J5 outward ITERATION complete.");

w6 = R65 * w5 + dQZ6;
dw6 = R65 * dw5 + cross(R65*w5, dQZ6) + ddQZ6;
dv6 = R65 * (cross(w5, P56) + cross(w5, cross(w5, P56)) + dv5);
dvc6 = cross(dw6, Pc6) + cross(w6, w6+Pc6) + dv6;
F6 = m6 * dvc6;
N6 = Ic6 * dw6 + cross(w6, Ic6*w6);
disp("<INFO> J6 outward ITERATION complete.");

w7 = R76 * w6 + dQZ7;
dw7 = R76 * dw6 + cross(R76*w6, dQZ7) + ddQZ7;
dv7 = R76 * (cross(w6, P67) + cross(w6, cross(w6, P67)) + dv6);
dvc7 = cross(dw7, Pc7) + cross(w7, w7+Pc7) + dv7;
F7 = m7 * dvc7;
N7 = Ic7 * dw7 + cross(w7, Ic7*w7);
disp("<INFO> J7 outward ITERATION complete.");

% inward ITERATION to compute forces and torques
% DEBUG: POINT 3
f7 = fe + F7;
n7 = N7 + ne + cross(Pc7, F7);
T7 = n7' * [0;0;1];
disp("<INFO> J7 inward ITERATION complete.");

f6 = R67 * f7 + F6;
n6 = N6 + R67 * n7 + cross(Pc6, F6) + cross(P67, R67 * f7);
T6 = n6' * [0;0;1];
disp("<INFO> J6 inward ITERATION complete.");

f5 = R56 * f6 + F5;
n5 = N5 + R56 * n6 + cross(Pc5, F5) + cross(P56, R56 * f6);
T5 = n5' * [0;0;1];
disp("<INFO> J5 inward ITERATION complete.");

f4 = R45 * f5 + F4;
n4 = N4 + R45 * n5 + cross(Pc4, F4) + cross(P45, R45 * f5);
T4 = n4' * [0;0;1];
disp("<INFO> J4 inward ITERATION complete.");

f3 = R34 * f4 + F3;
n3 = N3 + R34 * n4 + cross(Pc3, F3) + cross(P34, R34 * f4);
T3 = n3' * [0;0;1];
disp("<INFO> J3 inward ITERATION complete.");

f2 = R23 * f3 + F2;
n2 = N2 + R23 * n3 + cross(Pc2, F2) + cross(P23, R23 * f3);
T2 = n2' * [0;0;1];
disp("<INFO> J2 inward ITERATION complete.");

f1 = R12 * f2 + F1;
n1 = N1 + R12 * n2 + cross(Pc1, F1) + cross(P12, R12 * f2);
T1 = n1' * [0;0;1];
disp("<INFO> J1 inward ITERATION complete.");

%% INTEGRATE DYNAMIC EQUATION WITH FRICTION
T1 = T1 + Ia1*ddQ1 + fv1*dQ1 + fc1*sign(dQ1);
T2 = T2 + Ia2*ddQ2 + fv2*dQ2 + fc2*sign(dQ2);
T3 = T3 + Ia3*ddQ3 + fv3*dQ3 + fc3*sign(dQ3);
T4 = T4 + Ia4*ddQ4 + fv4*dQ4 + fc4*sign(dQ4);
T5 = T5 + Ia5*ddQ5 + fv5*dQ5 + fc5*sign(dQ5);
T6 = T6 + Ia6*ddQ6 + fv6*dQ6 + fc6*sign(dQ6);
T7 = T7 + Ia7*ddQ7 + fv7*dQ7 + fc7*sign(dQ7);
T = [T1; T2; T3; T4; T5; T6; T7];
disp("<INFO> DYNAMIC EQUATION obtained");


