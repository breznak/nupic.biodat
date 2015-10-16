# ECG anomaly detection experiment - Arrhythmia

## Dataset

 - [MIT-BIH Arrhythmia DB](http://physionet.org/physiobank/database/html/mitdbdir/mitdbdir.htm)

## Goal
 - detect arrhythmia as anomalies in ECG signals
 - can generalize to different patients? 
 - no need to specify WHICH anomaly it is, just normal (`N` label) vs. anomaly (anything else, `V` should be most visible, easiest)
  - TODO handle `PACED` patients - ignore?

## Run
 - Dependencies:
  - nupic
  - matlab

 - Run:
  - get data from matlab:
    - `matlab nacit.m` creates `data/out.csv` file to be processed
  - run model (predictions, anomaly score): `$NUPIC/scripts/run_opf_experiment.py model/`
    - you need to modify `DATA_FILE` in `model/description.py` to your path.
  - review resutls: in `model/` run `./format_output.sh > results.csv` 
  - improve:
    - modify params in `model/description.py` by hand
    - run `swarming` parameter optimization for models
