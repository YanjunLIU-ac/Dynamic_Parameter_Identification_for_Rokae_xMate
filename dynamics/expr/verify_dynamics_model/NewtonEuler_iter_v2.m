function T = NewtonEuler_iter_v2(q, qd, qdd)

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

%% LOAD PARAMETERS RESPECTIVELY FROM WORKSPACE
m1 = evalin('base','m1'); 
m2 = evalin('base','m2'); 
m3 = evalin('base','m3'); 
m4 = evalin('base','m4'); 
m5 = evalin('base','m5');
m6 = evalin('base','m6');
m7 = evalin('base','m7');

mc11 = evalin('base','mc11')/m1; mc12 = evalin('base','mc12')/m1; mc13 = evalin('base','mc13')/m1;
mc21 = evalin('base','mc21')/m2; mc22 = evalin('base','mc22')/m2; mc23 = evalin('base','mc23')/m2;
mc31 = evalin('base','mc31')/m3; mc32 = evalin('base','mc32')/m3; mc33 = evalin('base','mc33')/m3;
mc41 = evalin('base','mc41')/m4; mc42 = evalin('base','mc42')/m4; mc43 = evalin('base','mc43')/m4;
mc51 = evalin('base','mc51')/m5; mc52 = evalin('base','mc52')/m5; mc53 = evalin('base','mc53')/m5;
mc61 = evalin('base','mc61')/m6; mc62 = evalin('base','mc62')/m6; mc63 = evalin('base','mc63')/m6;
mc71 = evalin('base','mc71')/m7; mc72 = evalin('base','mc72')/m7; mc73 = evalin('base','mc73')/m7;

Ic111 = evalin('base','Ic111'); Ic122 = evalin('base','Ic122'); Ic133 = evalin('base','Ic133'); Ic112 = evalin('base','Ic112'); Ic113 = evalin('base','Ic112'); Ic123 = evalin('base','Ic123');
Ic211 = evalin('base','Ic211'); Ic222 = evalin('base','Ic222'); Ic233 = evalin('base','Ic233'); Ic212 = evalin('base','Ic212'); Ic213 = evalin('base','Ic213'); Ic223 = evalin('base','Ic223');
Ic311 = evalin('base','Ic311'); Ic322 = evalin('base','Ic322'); Ic333 = evalin('base','Ic333'); Ic312 = evalin('base','Ic312'); Ic313 = evalin('base','Ic313'); Ic323 = evalin('base','Ic323');
Ic411 = evalin('base','Ic411'); Ic422 = evalin('base','Ic422'); Ic433 = evalin('base','Ic433'); Ic412 = evalin('base','Ic412'); Ic413 = evalin('base','Ic413'); Ic423 = evalin('base','Ic423');
Ic511 = evalin('base','Ic511'); Ic522 = evalin('base','Ic522'); Ic533 = evalin('base','Ic533'); Ic512 = evalin('base','Ic512'); Ic513 = evalin('base','Ic513'); Ic523 = evalin('base','Ic523');
Ic611 = evalin('base','Ic611'); Ic622 = evalin('base','Ic622'); Ic633 = evalin('base','Ic633'); Ic612 = evalin('base','Ic612'); Ic613 = evalin('base','Ic613'); Ic623 = evalin('base','Ic623');
Ic711 = evalin('base','Ic711'); Ic722 = evalin('base','Ic722'); Ic733 = evalin('base','Ic733'); Ic712 = evalin('base','Ic712'); Ic713 = evalin('base','Ic713'); Ic723 = evalin('base','Ic723');

Ia1 = evalin('base','Ia1');
Ia2 = evalin('base','Ia2');
Ia3 = evalin('base','Ia3');
Ia4 = evalin('base','Ia4');
Ia5 = evalin('base','Ia5');
Ia6 = evalin('base','Ia6');
Ia7 = evalin('base','Ia7');

fv1 = evalin('base','fv1');
fc1 = evalin('base','fc1');
fv2 = evalin('base','fv2');
fc2 = evalin('base','fc2');
fv3 = evalin('base','fv3');
fc3 = evalin('base','fc3');
fv4 = evalin('base','fv4');
fc4 = evalin('base','fc4');
fv5 = evalin('base','fv5');
fc5 = evalin('base','fc5');
fv6 = evalin('base','fv6');
fc6 = evalin('base','fc6');
fv7 = evalin('base','fv7');
fc7 = evalin('base','fc7');

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
% position of CoG of link
Pc1 = [mc11; mc12; mc13];
Pc2 = [mc21; mc22; mc23];
Pc3 = [mc31; mc32; mc33];
Pc4 = [mc41; mc42; mc43];
Pc5 = [mc51; mc52; mc53];
Pc6 = [mc61; mc62; mc63]; 
Pc7 = [mc71; mc72; mc73];
% inertia matrix w.r.t. CoG
Ic1 = [Ic111 Ic112 Ic113; Ic112 Ic122 Ic123; Ic113 Ic123 Ic133]; 
Ic2 = [Ic211 Ic212 Ic213; Ic212 Ic222 Ic223; Ic213 Ic223 Ic233]; 
Ic3 = [Ic311 Ic312 Ic313; Ic312 Ic322 Ic323; Ic313 Ic323 Ic333]; 
Ic4 = [Ic411 Ic412 Ic413; Ic412 Ic422 Ic423; Ic413 Ic423 Ic433]; 
Ic5 = [Ic511 Ic512 Ic513; Ic512 Ic522 Ic523; Ic513 Ic523 Ic533];
Ic6 = [Ic611 Ic612 Ic613; Ic612 Ic622 Ic623; Ic613 Ic623 Ic633]; 
Ic7 = [Ic711 Ic712 Ic713; Ic712 Ic722 Ic723; Ic713 Ic723 Ic733]; 
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
T = 1e-3 * [T1; T2; T3; T4; T5; T6; T7];

end

