Steps to run this project:

1. /dynamics: 
- deduce robot dynamic model through Newton-Euler method.
- linearize robot dynamic model to obtain regressor.
- apply QR decomposition to obtain minimal regressor.
- convert minimal parameter set Pmin to standard set.
- verify error between observation and NE-based estimation. 
- deduce robot dynamic equation item.
see `run_dynamics.m` for details. 

2. /excitation:
- optimize excitation trajectory based on cond of minimal regressor.
- matrixized constraints for trajectory optimization:
|q| < qmax, |qd| < qdmax, |qdd| < qddmax, q0=qn=q_init
- plot figures of {q, qd, qdd, cart_pos} and also animation.
- cpp scripts for running excitation trajectory based on rci client. 
see `run_optimize.m` for details.

3. /filtering:
- downsample observation data to assigned size.
- apply butterworth and zero-phase filter to q, qd, qdd, tau data.
- plot figures of raw and filtered data.
see `run_filtering.m` for details.

4. /identify:
- apply LSE (least square estimation) to figure out minimal param set.
- verify error between observation and estimation by min regressor.
see `run_identify.m` for details.

Usage scenarios:
1. Excitation Trajectory Optimization:
obtain min regressor matrix in `\dynamics` and then turn to `\excitation`

2. Validation Error Verification:
copy raw sensor data in `\filtering` and then turn to `\dynamics`



