Run:
1. run `run_identify.m` PART I to implement LSE method to compute minimal parameter set (P_min)
2. run `run_identify.m` PART II to verify identification performance using minimal parameter set (W_min and P_min)

Scripts:
1. `least_square_estimation_syms.m`(`least_square_estimation_math.m`):
   to apply least square method for parameter estimation.
2. `verify_identified_parameter.m`:
   compute torque using inverse dynamics and compare identified results with raw torque data.
3. `minparam_inverse_dynamics.m`: 
   inverse dynamics to compute joint torque (either symbol-based W_min or arithmetic-based W_min is provided and needed to be specified)

Data:
1. Before and after `least_square_estimation_syms.m`:
- before run, load filter trajectory data and minimal regression matrix using `data_filtering.mat`, `W_min.mat`
- after run, save workspace to `least_square.mat` 
- after run, save expression string to `P_min.txt`

2. After `verify_identified_parameter.m`:
- plot identified results and errors to folder `figs`
- error results (difference) saved to `figs/diff/diffN.png`
- error results (holistic difference) saved to `figs/holistic_diff.png`
- identified results saved to `figs/idy/idyN.png`

Notes:
all filtered torque data has been multiplied by 1e3 when applied least square method to satisfy: 
W_min (unit: Nmm) · P_min (unit: Nmm) = T (unit: Nmm)
thus the unit of identified parameter set (P_min) is Nmm