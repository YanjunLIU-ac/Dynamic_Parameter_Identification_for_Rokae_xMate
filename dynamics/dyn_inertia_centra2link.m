%% dyn_inertia_centra2link.m
% @brief: convert CoG notation of link to inertia notation of link
%         (Refer to `Study on Parameter Identification for Rokae XB4`)
% @notes: centraTAU consists of dynamic parameters
%         {m, mc1, mc2, mc3, Ic11, Ic22, Ic33, Ic12, Ic13, Ic23, Ia, fv, fc}
%         while linkTAU consists of dynamic parameters
%         {m, mc1, mc2, mc3, Io11, Io22, Io33, Io12, Io13, Io23, Ia, fv, fc}
% @notes: Unit:mm(Nmm) is used throughout the project.

%% PARAMETERS
% inertia tensor w.r.t. link
%   Io denotes I^{O_i}, where {O_i} is the origin of link frame {i}.
syms Io111 Io122 Io133 Io112 Io113 Io123 real;
syms Io211 Io222 Io233 Io212 Io213 Io223 real;
syms Io311 Io322 Io333 Io312 Io313 Io323 real;
syms Io411 Io422 Io433 Io412 Io413 Io423 real;
syms Io511 Io522 Io533 Io512 Io513 Io523 real;
syms Io611 Io622 Io633 Io612 Io613 Io623 real;
syms Io711 Io722 Io733 Io712 Io713 Io723 real;
% position of CoM
% Pc1 = [mc11; mc12; mc13]; 
% Pc2 = [mc21; mc22; mc23]; 
% Pc3 = [mc31; mc32; mc33]; 
% Pc4 = [mc41; mc42; mc43]; 
% Pc5 = [mc51; mc52; mc53]; 
% Pc6 = [mc61; mc62; mc63]; 
% Pc7 = [mc71; mc72; mc73];
disp("<INFO> PARAMETERS Loaded!!");

%% VECTORIZATION
% inertia matrix w.r.t link
Io1 = [Io111 Io112 Io113; Io112 Io122 Io123; Io113 Io123 Io133]; 
Io2 = [Io211 Io212 Io213; Io212 Io222 Io223; Io213 Io223 Io233]; 
Io3 = [Io311 Io312 Io313; Io312 Io322 Io323; Io313 Io323 Io333]; 
Io4 = [Io411 Io412 Io413; Io412 Io422 Io423; Io413 Io423 Io433]; 
Io5 = [Io511 Io512 Io513; Io512 Io522 Io523; Io513 Io523 Io533]; 
Io6 = [Io611 Io612 Io613; Io612 Io622 Io623; Io613 Io623 Io633]; 
Io7 = [Io711 Io712 Io713; Io712 Io722 Io723; Io713 Io723 Io733]; 
disp("<INFO> VECTORIZATION complete!!");

%% INSTANTIATION
% figure out Ic from Io
I = sym(eye(3));
Ic1 = Io1 - m1 * (Pc1'*Pc1*I - Pc1*Pc1');
Ic2 = Io2 - m2 * (Pc2'*Pc2*I - Pc2*Pc2');
Ic3 = Io3 - m3 * (Pc3'*Pc3*I - Pc3*Pc3');
Ic4 = Io4 - m4 * (Pc4'*Pc4*I - Pc4*Pc4');
Ic5 = Io5 - m5 * (Pc5'*Pc5*I - Pc5*Pc5');
Ic6 = Io6 - m6 * (Pc6'*Pc6*I - Pc6*Pc6');
Ic7 = Io7 - m7 * (Pc7'*Pc7*I - Pc7*Pc7');
disp("<INFO> CONVERTED centralInertia to linkInertia.");
% instantiate Ic in dynamic equation
linkTAU = subs(centraTAU,  ...
              {'Ic111', 'Ic122', 'Ic133', 'Ic112', 'Ic113', 'Ic123',  ...
	           'Ic211', 'Ic222', 'Ic233', 'Ic212', 'Ic213', 'Ic223',  ...
	           'Ic311', 'Ic322', 'Ic333', 'Ic312', 'Ic313', 'Ic323',  ...
	           'Ic411', 'Ic422', 'Ic433', 'Ic412', 'Ic413', 'Ic423',  ...
	           'Ic511', 'Ic522', 'Ic533', 'Ic512', 'Ic513', 'Ic523',  ...
	           'Ic611', 'Ic622', 'Ic633', 'Ic612', 'Ic613', 'Ic623',  ...
	           'Ic711', 'Ic722', 'Ic733', 'Ic712', 'Ic713', 'Ic723'}, ...
              {Ic1(1, 1), Ic1(2, 2), Ic1(3, 3), Ic1(1, 2), Ic1(1, 3), Ic1(2, 3),  ...
	           Ic2(1, 1), Ic2(2, 2), Ic2(3, 3), Ic2(1, 2), Ic2(1, 3), Ic2(2, 3),  ...
	           Ic3(1, 1), Ic3(2, 2), Ic3(3, 3), Ic3(1, 2), Ic3(1, 3), Ic3(2, 3),  ...
	           Ic4(1, 1), Ic4(2, 2), Ic4(3, 3), Ic4(1, 2), Ic4(1, 3), Ic4(2, 3),  ...
	           Ic5(1, 1), Ic5(2, 2), Ic5(3, 3), Ic5(1, 2), Ic5(1, 3), Ic5(2, 3),  ...
	           Ic6(1, 1), Ic6(2, 2), Ic6(3, 3), Ic6(1, 2), Ic6(1, 3), Ic6(2, 3),  ...
	           Ic7(1, 1), Ic7(2, 2), Ic7(3, 3), Ic7(1, 2), Ic7(1, 3), Ic7(2, 3)});
disp("<INFO> INSTANTIATION complete!!");

