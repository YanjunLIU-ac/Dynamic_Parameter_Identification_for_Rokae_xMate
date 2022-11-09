%% PART I-A: DERIVE ROBOT DYNAMICS
if 0
    clear, clc, close all;
	
	%% Central Dynamics
    dyn_central_newtoneuler;
    % Save to txt
	t1 = char(T1); t2 = char(T2); t3 = char(T3); t4 = char(T4); t5 = char(T5); t6 = char(T6); t7 = char(T7);
    fid = fopen('.\data\txt\dyn_central_newtoneuler.txt', 'w');
    fprintf(fid, ...
        'T1=%s\rT2=%s\rT3=%s\rT4=%s\rT5=%s\rT6=%s\rT7=%s\r', ...
        t1, t2, t3, t4, t5, t6, t7);
    fclose(fid);
    % Save to mat
	clear fid t1 t2 t3 t4 t5 t6 t7 ans;
    save('.\data\mat\dyn_central_newtoneuler.mat')
    
	%% Link-side Dynamics
    dyn_inertia_centra2link;
	% Save to txt
    fid = fopen('.\data\txt\dyn_inertia_centra2link.txt','w');
    fprintf(fid, ...
        'T1=%s\rT2=%s\rT3=%s\rT4=%s\rT5=%s\rT6=%s\rT7=%s\r', ...
        char(linkTAU(1)), char(linkTAU(2)), char(linkTAU(3)), ...
        char(linkTAU(4)), char(linkTAU(5)), char(linkTAU(6)), char(linkTAU(7)));
    fclose(fid);
	% Save to mat
    clear fid I ans;
    save('.\data\mat\dyn_inertia_centra2link.mat')
    
	%% Retrieve Regression Matrix
    dyn_param_linearization;
	% Save to txt
    fid = fopen('.\data\txt\dyn_param_linearization.txt','w');
    for i = 1:7
        for j = 1:pnum_sum
		    fprintf(fid, 'w%d%d=%s;\r', i, j, char(W(i, j)));
        end
    end
    fclose(fid);
	% Save to mat
    clear fid i j k1 k2 Q_ ans;
    save('.\data\mat\dyn_param_linearization.mat')
    save('.\data\mat\regressor.mat', 'W');
end

%% MANUALLY:
% 1. convert SystemOfUnits of {DH, g} to {mm} in `dyn_minimal_param_math.m`, `dyn_minimal_param_syms.m` and `utils\regressor.m`
% 2. copy scripts in `data\txt\dyn_param_linearization.txt` to `utils\regressor.m`
% 3. address inf/nan substitution in `dyn_minimal_syms.m` (line 63)

%% PART 1-B: DERIVE ROBOT DYNAMICS
if 0
	%% Derive Minimum Regression Matrix (QR decomposition)
    dyn_minimal_param_syms;  % (OR dyn_minimal_param_math)
    % Save to mat
    clear ans;
    save('.\data\mat\dyn_minimal_param_syms.mat');  % (OR save('.\data\mat\dyn_minimal_param_math.mat') )
    save('.\data\mat\min_regressor.mat', 'W_min');
    save('..\identify\data\min_regressor.mat', 'W_min');
end

% MANUALLY:
% modify Système International d'Unités of {DH, G} in `..\excitation\utils\min_regressor.m` and '..\excitation\optimize_object_fun_syms.m'
% copy scripts in `data\txt\dyn_minimal_param_math.txt` or `data\txt\dyn_minimal_param_syms.txt` to `..\excitation\utils\min_regressor.m`

%% PART II: DEDUCE STANDARD PARAMETER SET
if 1
	% Load necessary data
    clear, clc, close all;
    load('.\data\mat\dyn_minimal_param_syms.mat'); % (OR load('.\data\mat\dyn_minimal_param_math.mat'))
    load('.\data\mat\least_square.mat');
    %% MANUALLY: ADJUST DESIRED VIRTUAL MASS FOR EACH JOINT (line 33)
    %% Map mini param set P_min to standard param set P
	dyn_mapping_Pmin2P;
	% Save to mat
    clear ans;
    save('.\data\mat\mapping_Pmin2P.mat');
    save('.\data\mat\P_link.mat', 'P_link');
    save('.\data\mat\P_center.mat', 'P_center');
    save('.\utils\gen_params\P_center.mat', 'P_center');
    save('.\utils\gen_params\P_link.mat', 'P_link');
	% Save to txt
    addpath('.\utils\')
    mat2txt('.\data\txt\P_center.txt', P_center);
    mat2txt('.\data\txt\P_link.txt', P_link);
    rmpath('.\utils\')
    % OPTION: Run utils\gen_params\gen_param_cpp_matlab.py to generate desired variables
end

%% PART III: VERIFY STANDATD PARAMETER SET
if 1
    clear, clc, close all;
    load('.\data\mat\mapping_Pmin2P.mat');
    load('.\data\mat\excit_filtering.mat');
    
    % % For 12 params each joint
    % P_center = [ ...
    % P_center(1:10);0;P_center(11:12);
    % P_center(13:22);0;P_center(23:24);
    % P_center(25:34);0;P_center(35:36);
    % P_center(37:46);0;P_center(47:48);
    % P_center(49:58);0;P_center(59:60);
    % P_center(61:70);0;P_center(71:72);
    % P_center(73:82);0;P_center(83:84)];
    
    %% REMEMBER MAUNALLY:
    % check Système International d'Unités of {DH, G} in
    % - `compute_model_error.m`
    % - `NewtonEuler91.m`
    
    run('.\expr\verify_dynamics_model\compute_model_error.m');
end