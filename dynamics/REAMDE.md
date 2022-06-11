Use:
1. Deduce robot dynamics: run `run_dynamics.m` PART I
(NEED MANUAL SUBSTITUTION AND Système International d'Unités REINSPECTION BETWEEN PART 1-A AND PART 1-B)
2. Deduce standard parameter set from minimal parameter set: run `run_dynamics.m` PART II
3. Compute the error between torque observation and NE-based estimation: run `run_dynamics.m` PART III

Scripts:
1. `dyn_central_netwoneuler.m`: 
   deduce torque syms using netwon-euler iteration method based on central inertial (Ic)
2. `dyn_inertial_centra2link.m`:
   convert central inertial (Ic) to link inertial (Io) and obtain torque syms
3. `dyn_param_linearization.m`:
   linearize torque equation and obtain regression matrix (W)
4. `dyn_minimal_param_syms.m`:
   QR decomposition to obtain minimal regression matrix (W_min) based on syms,
   (alternative: `dyn_minimal_param_math.m` based on arithmetic expression from step(3.))
5. `dyn_mapping_Pmin2P.m`:
   mapping minimal parameter set (P_min) to centra-based standard set (P_center) and link-based standard set (P_link)

Data:
1. `data/mat`: 
- results from scripts (1-5) 
- results from least square estimation (needed by Pmin2P)
- results from data filtering (needed by error computation)
2. `data/txt`: 
- results from scripts (1-5)
- results of standard parameter set P_link (w.r.t. joint) and P_center (w.r.t. centra)

Experiments:
1. `verify_dynamics_model`:
compute error between joint torque observation (obtained by sensors) and 
NE-based joint torque estimation (excitation or validation traj, based on standard param set)

Utils:
1. `mat2txt.m`: convert MATLAB variable (vector) to txt
4. `\gen_params`: generate C++ macro-definitions, C++ and MATLAB variable expression
2. `regressor.m`: figure out standard regressor matrix W by arithmetic expression
3. `subs_power_item.py`: substitute '^2' in MATLAB-generated txt to 'pow(~,2)' used in cpp 

Notes:
- exprimental results show that maybe identification with P_link is better
- Système International d'Unités is very important in identification, so keep it consistent.

   