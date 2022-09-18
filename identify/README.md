This directory contains all the necessary theoretical and pratical codes of parameter identification. We have integrated all the necessary MATLAB codes in `run_identify.m`. Thus, you do not need to run these scripts independently. Read the following descriptions and codes for further details.

## Usage:
* Step 1: Implement LSE method to compute minimal parameter set (P_min): run `run_identify.m` PART I 
* Step 2: Verify identification performance using minimal parameter set (W_min and P_min): run `run_identify.m` PART II 

## Scripts:
* `least_square_estimation_syms.m`:
   Apply least square method for parameter estimation.
   (alternative: `least_square_estimation_math.m` based on arithmetic expression for faster computation)
* `minparam_inverse_dynamics.m`: 
   Compute joint torque using minimal regressor and parameter set (either symbolic W_min or arithmetic W_min is provided and the option is yours)  
* `verify_identified_parameter.m`:
   Compute torque estimation using inverse dynamics and compare identified results with raw torque data.


Note that no significant difference between the results of symbolic and arithemtic method is observed. The advantage of symbolic method is that it yields more accurate results and addresses truncation errors to some extent, but it may encounter numerical problems (inf/nan) and its speed is slower. Arithmetic expressions provide faster calculation speed and can solve the inf/nan problem. You can check the code for more details

## Data and figures:
* Before running `least_square_estimation_syms.m`:
  - filtered trajectory data and minimal regression matrix `data_filtering.mat`, `W_min.mat` is loaded.
* After running `least_square_estimation_syms.m`:
  - MATLAB workspace is saved to `least_square.mat`.
  - expression string is saved to `P_min.txt`.
* After running `verify_identified_parameter.m`:
  - identified results and errors is  plot under folder `figs`
    - error results (difference) saved to `figs/diff/diffN.png` (N denotes the joint No., ranges from 1~7)
    - error results (holistic difference) saved to `figs/holistic_diff.png`
    - identified results saved to `figs/idy/idyN.png` (N denotes the joint No., ranges from 1~7)

## Notes:
All filtered torque data has been multiplied by 1e3 when applied least square method to satisfy: `W_min (unit: Nmm) · P_min (unit: Nmm) = T (unit: Nmm)` ,thus the unit of identified parameter set (P_min) is Nmm.