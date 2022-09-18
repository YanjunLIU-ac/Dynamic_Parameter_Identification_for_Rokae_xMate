This directory contains all the necessary theoretical formulation and deduction of dynamics equation. We have integrated all the necessary MATLAB codes in `run_dynamics.m`. Thus, you do not need to run these scripts independently. Read the following descriptions for further details.

## Usage:
* Step 1: Model robot dynamics by symbolic toolbox: run `run_dynamics.m` PART I  
(NEED MANUAL SUBSTITUTION AND Système International d'Unités REINSPECTION BETWEEN PART 1-A AND PART 1-B)  
* Step 2: Recover standard from minimal parameter set: run `run_dynamics.m` PART II  
* Step 3: Compute the error between torque observation and estimation: run `run_dynamics.m` PART III  

## Scripts:
* `dyn_central_netwoneuler.m`:  
   Formulate torque variable w.r.t central inertial (Ic) using Netwon-Euler (N-E) iteration method.
* `dyn_inertial_centra2link.m`:  
   Convert central inertial (Ic) to link inertial (Io) and obtain torque variable w.r.t. link inertial (Io).
* `dyn_param_linearization.m`:  
   Linearize dynamics equation and obtain regression matrix (W) which satisfys Wd=τ, d being the dynamic parameters.
* `dyn_minimal_param_syms.m`:  
   Apply QR decomposition to obtain minimal regression matrix (W_min) based on symbolic calculation.
   (alternative: `dyn_minimal_param_math.m` based on arithmetic expression for faster computation)
* `dyn_mapping_Pmin2P.m`:  
   Map minimal parameter set (P_min) to centra-based standard set (P_center) and link-based standard set (P_link).  
   Note: This script should run after the identification process.

## Data:
* `data/mat/`: 
  - results from scripts: check the `.mat` file with names corresponding to scripts.
  - results from least square estimation (needed by Pmin2P): `least_square.mat`
  - results from data filtering (needed by error computation): `excit_filtering.mat`
  - centra-based standard set (P_center): `P_center.mat`
  - link-based standard set (P_link): `P_link.mat`
  - [minimal] regression matrix (W_min): `regressor.mat`, `min_regressor.mat`
* `data/txt/`: 
  - results from scripts (1-5): check the `.txt` file with names corresponding to scripts.
  - results of standard parameter set P_link (w.r.t. joint) and P_center (w.r.t. centra): `P_link.txt`, `P_center.txt`

## Experiments:
* `expr/verify_dynamics_model/`:
The scripts under this directory can be used to compute error between joint torque observation (obtained by sensors) and NE-based joint torque estimation (excitation or validation traj, based on standard param set)

## Utils:
* `utils/mat2txt.m`: convert MATLAB variable (vector) to txt
* `utils/regressor.m`: figure out standard regressor matrix W by arithmetic expression
* `utils/subs_power_item.py`: substitute '^2' in MATLAB-generated txt to 'pow(~,2)' used in cpp
* `utils/gen_params/`: generate C++ macro-definitions, C++ and MATLAB variable expression

## Notes:
- Exprimental results show that maybe identification with P_link is better
- Système International d'Unités is very important in identification, so keep it consistent.