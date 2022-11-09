%% dyn_central_newtoneuler.m
% @brief: Deduce dynamic equation for Rokae xMate3Pro by syms
%		  frame{base} -> frame{1} ... frame{7} -> frame{end-effector}
%         (frame{base} = frame{0}, frame{7} = frame{ee})
% @notes: 
% 		1. Iterative Netwon-Euler Dynamic Formulation; 
% 		2. Modified D-H modelling scheme for Pmn & Rmn,
% 		3. Central inertial notation Icmn for link inertial
%       4. Unit:mm(Nmm) is used throughout this project.

%% PARAMETERS
% sine and cosine of joint angle
syms s1 c1 s2 c2 s3 c3 s4 c4 s5 c5 s6 c6 s7 c7 real;
% DH parameter
syms d1 d3 d5 d7 real;
% joint velocity
syms dQ1 dQ2 dQ3 dQ4 dQ5 dQ6 dQ7 real;
% joint acceleration
syms ddQ1 ddQ2 ddQ3 ddQ4 ddQ5 ddQ6 ddQ7 real;
% position of CoM (Center of Mass)
syms mc11 mc12 mc13 real;
syms mc21 mc22 mc23 real;
syms mc31 mc32 mc33 real;
syms mc41 mc42 mc43 real;
syms mc51 mc52 mc53 real;
syms mc61 mc62 mc63 real;
syms mc71 mc72 mc73 real;
% inertia tensor w.r.t CoM
%   Ic denotes I^{C_i}, where {C_i} has its origin at the center of mass of
%   the link and has same orientation as the link frame {i}.
syms Ic111 Ic122 Ic133 Ic112 Ic113 Ic123 real;
syms Ic211 Ic222 Ic233 Ic212 Ic213 Ic223 real;
syms Ic311 Ic322 Ic333 Ic312 Ic313 Ic323 real;
syms Ic411 Ic422 Ic433 Ic412 Ic413 Ic423 real;
syms Ic511 Ic522 Ic533 Ic512 Ic513 Ic523 real;
syms Ic611 Ic622 Ic633 Ic612 Ic613 Ic623 real;
syms Ic711 Ic722 Ic733 Ic712 Ic713 Ic723 real;
% link mass
syms m1 m2 m3 m4 m5 m6 m7 real;
% link inertia
syms Ia1 Ia2 Ia3 Ia4 Ia5 Ia6 Ia7 real;
% external force/torque acting on ee
syms fe1 fe2 fe3 ne1 ne2 ne3 real;
% gravitional acceleration
syms g real;
% friction model (viscous, coulomb)
syms fv1 fc1 fv2 fc2 fv3 fc3 fv4 fc4 fv5 fc5 fv6 fc6 fv7 fc7 real;
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
disp("<INFO> PARAMETERS Loaded!!");

%% VECTORIZATION
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
P01 = [0; 0; d1];
P12 = [0; 0; 0];
P23 = [0; -d3; 0];
P34 = [0; 0; 0];
P45 = [0; -d5; 0];
P56 = [0; 0; 0];
P67 = [0; -d7; 0];
P7e = [0; 0; 0];
% position of CoM on link
Pc1 = [mc11; mc12; mc13];
Pc2 = [mc21; mc22; mc23];
Pc3 = [mc31; mc32; mc33];
Pc4 = [mc41; mc42; mc43];
Pc5 = [mc51; mc52; mc53];
Pc6 = [mc61; mc62; mc63]; 
Pc7 = [mc71; mc72; mc73];
% inertia matrix w.r.t. CoM
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

%% INTEGRATE DYNAMIC EQUATION WITH FRICTION (7x1 syms)
T1 = T1 + Ia1*ddQ1 + fv1*dQ1 + fc1*sign(dQ1);
T2 = T2 + Ia2*ddQ2 + fv2*dQ2 + fc2*sign(dQ2);
T3 = T3 + Ia3*ddQ3 + fv3*dQ3 + fc3*sign(dQ3);
T4 = T4 + Ia4*ddQ4 + fv4*dQ4 + fc4*sign(dQ4);
T5 = T5 + Ia5*ddQ5 + fv5*dQ5 + fc5*sign(dQ5);
T6 = T6 + Ia6*ddQ6 + fv6*dQ6 + fc6*sign(dQ6);
T7 = T7 + Ia7*ddQ7 + fv7*dQ7 + fc7*sign(dQ7);
centraTAU = [T1; T2; T3; T4; T5; T6; T7];
disp("<INFO> DYNAMIC EQUATION obtained");
