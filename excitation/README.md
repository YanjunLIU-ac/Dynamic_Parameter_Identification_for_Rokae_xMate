This directory contains all the necessary codes for excitation trajectory generation and optimization. We have integrated all the necessary MATLAB codes in `run_optimize.m`. Thus, you do not need to run these scripts independently. Read the following descriptions and codes for further details.

## Usage:
Follow the codes in `run_optimze.m`. 

Note that identification using motor torque data instead of joint torque data is also acceptable. But the corresponding dynamics model needs to be modified.

## Scripts:
* `optimize_traj_main.m`:
  Main optimization script. The target cost function and constraints are integrated here and we use function MATLAB built-in toolbox `fmincon` for optimization. 
* `optimize_traj_constraints_mat.m`:
  Formulate the equality and inequality constraints for joint motion directly from Fourier-based series.
  (alternatively, `optimize_traj_constraints_fun.m` formulate the equality and inequality constraints using trajectory generation function)
* [RECOMMENDED] `optimize_traj_object_fun_math.m`:
  Derive the optimization cost function (the condition number of minimal regressor) based on arithmetic expression 
  (alternatively, `optimize_traj_object_fun_syms.m` figures out cost function based on the subsitution of symbolic expression, which is much slower than the recommended implementation)
* `optimal_traj_vis.m.m`:
  Visualize the optimized excitation trajectory and print out the desired figures.
* [OPTIONAL] `optimize_traj_nonl_constraints.m`:
  Formulate nonlinear geometric constraints to avoid self-collision during executing excitation trajectory.

## Utils:
* `traj_func.m`:
  Generate q, qd, qdd of the Fourier-series trajectory based on the given parameters.
* `min_regressor.m`:
  Compute the min regressor matrix (W_B) numerically according to the arithmetic expression.

## Data and figures:
All the raw data collected from sensors are provided as `.txt` file in the directory `./data/excit` and all the filtered data is also stored here as `.mat` file. Refer to `./data/excit/README.md` for details. The relevant figures are stored in `./figs/train/`.