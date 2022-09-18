This directory contains all the necessary codes for data filtering. We have integrated all the necessary MATLAB codes in `run_filtering.m`. Thus, you do not need to run these scripts independently. Read the following descriptions and codes for further details.

## Usage:
Follow the codes in `run_filtering.m`:  
* Step 1: Downsample raw motion data from sensor readings: filtering out repetitive data and accelerate the identification process  
* Step 2: Apply zero-phase digital filtering to joint angle, velocity, acceleration and torque data.  

Note that identification using motor torque data instead of joint torque data is also acceptable. But the corresponding dynamics model needs to be modified.

## Scripts:
* `downsampling.m`:
  Apply average sampling method to raw joint angle, velocity, acceleration and torque data. The downsampling rate should be specified manually.
* `ang_filter.m`:
  Apply offline zero-phase butterworth filtering to downsampled joint angle data. 
* `vel_filter.m`:
  Apply offline zero-phase butterworth filtering to downsampled joint velocity data. Either sensor readings or derivtive from joint angle data can be specified. By default, we use sensor readings for filtering.
* `acc_filter.m`:
  Apply offline zero-phase butterworth filtering to downsampled joint acceleration data. Either sensor readings or derivtive from joint velocity data can be specified. By default, we use sensor the derivative of filtered joint velocity data as the source signal for filter.
* `trq_filter.m`:
  Apply offline zero-phase butterworth filtering to downsampled joint torque data.

## Data:
All the raw data collected from sensors are provided as `.txt` file in the directory `./data/excit/` and all the filtered data is also stored here as `.mat` file. Refer to `./data/excit/README.md` for details.

## Figures:
The comparison between pre-filtering and filtered motion data are stored in the directory `./figs/excit/` and the corresponding codes can be found in corresponding individual filter scripts.