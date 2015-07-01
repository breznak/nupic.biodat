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
