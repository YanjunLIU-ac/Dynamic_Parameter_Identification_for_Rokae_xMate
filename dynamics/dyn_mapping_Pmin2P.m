%% dyn_mapping_Pmin2P.m
% @brief: recover all 91 dynamic parameters from minimal parameter set
% THEORETICAL DERIVATION:
%       W = QR, R = [R1, R2], P = [P1, P2] 
%       ==> P_min = P1 * (inv(R1) * R2) * P2
%   While finding P (full param set) from P_min (minimal param set), there 
% are infinite feasible solutions and all of them are equivalent. THUS, 
% only one feasible solution needs to be found.
%   ASSUME param other than m equals to 0, then mass can be defined
% arbitrarily, which is defined as 0.001 here. THEN, all we have to do
% before figuring out P is to obtain the values of P1.
% ==> P1 = P_min - (inv(R1) * R2) * P2
% @note: Unit:mm is used throughout the project.
function dyn_mapping_Pmin2P()

%% PARAMETERS
% number of all dynamic params
pnum_sum = evalin('base', 'pnum_sum');
% number of dynamic params per joint
pnum_per_joint = evalin('base', 'pnum_per_joint');
% minimal param regression
P_min = evalin('base', 'P_min');
R1 = evalin('base', 'R1');
R2 = evalin('base', 'R2');
pnum_min = evalin('base', 'pnum_min');
min_param_ind = evalin('base', 'min_param_ind');
% full param set w.r.t. link
P_link = zeros(pnum_sum, 1);
% dependent param set
P2 = zeros(pnum_sum - pnum_min, 1);

%% FIGURE OUT P2 (given m=0.01 here)
m = [10, 0.01, 0.01, 0.01, 0.01, 0.01, 0.01] * 45;
cnt2 = 0;   % counter for P2
cntm = 0;   % counter for mass
for ii = 1:pnum_sum
    if (min_param_ind(ii) == 0)
        cnt2 = cnt2 + 1;
        if (mod((ii-1), pnum_per_joint) == 0)
            cntm = cntm + 1;
            P2(cnt2) = m(cntm);
        end
    end
end

%% FIGURE OUT P1
P1 = P_min - (R1 \ R2) * P2;

%% FIGURE OUT P (w.r.t. link)
cnt1 = 0;   % counter for P1
cnt2 = 0;   % counter for P2
for ii = 1:pnum_sum
    if (min_param_ind(ii) == 0)
        cnt2 = cnt2 + 1;
        P_link(ii) = P2(cnt2);
    else
        cnt1 = cnt1 + 1;
        P_link(ii) = P1(cnt1);
    end
end

%% FIGURE OUT P_center (inertia w.r.t. CoG)
I = eye(3);
% full param set w.r.t. (center of) mass
P_center = P_link;
% mass per joint
m_ = 0;
% link inertia (Io, Ic) per joint
Io_ = zeros(3, 3);
Ic_ = zeros(3, 3);
% CoG per joint w.r.t. link mass (percentage): mi*mci1,mi*mci2,mi*mci3
Pc_ = zeros(3, 1);
% order: {m, mc1, mc2, mc3, Ioxx, Ioyy, Iozz, Ioxy, Ioxz, Ioyz, Ia, fv, fc}
for kk = 1:7
    ind = pnum_per_joint * (kk - 1);  % (start index - 1) per joint 
    
    m_ = P_link(ind+1);
    Pc_ = [P_link(ind+2), P_link(ind+3), P_link(ind+4)] / m_;
    Io_ = [P_link(ind+5), P_link(ind+8), P_link(ind+9);
           P_link(ind+8), P_link(ind+6), P_link(ind+10);
           P_link(ind+9), P_link(ind+10), P_link(ind+7)];
    
    % inertia w.r.t. center of link (Ic)
    Ic_ = Io_ - m_ * (Pc_' * Pc_ * I - Pc_ * Pc_');
    P_center(ind+5:ind+10) = [Ic_(1,1), Ic_(2,2), Ic_(3,3), Ic_(1,2), Ic_(1,3), Ic_(2,3)];

    P_center(ind+2:ind+4) = P_center(ind+2:ind+4) / m_;
end

%% SAVE TO TXT
fid = fopen('.\data\txt\P_center.txt', 'w');
fprintf(fid, 'P_center = [');
for j = 1:pnum_min
    fprintf(fid, '%s;', P_center(j));
end
fprintf(fid, '];');

fid = fopen('.\data\txt\P_link.txt', 'w');
fprintf(fid, 'P_link = [');
for j = 1:pnum_min
    fprintf(fid, '%s;', P_link(j));
end
fprintf(fid, '];');

%% SAVE VARIABLE TO BASE WORKSPACE
assignin('base', 'P_link', P_link)
assignin('base', 'P_center', P_center)