function [signal, annotation, time, header, ecg] = readECGSamplePhysionet(fileName, pathDB)
%% readECGSamplePhysionet
% this function loads data from MIT-BIH database of ECG [1]
% params:
%  fileName = name of file (without suffix, eg '100')
%  pathDBDB = pat to the database, eg '~/mydata/mitdb/'
% returns:
%  signal = the ECG signal, 360Hz sampling, 10mV 
%TODO what is signal 2?
%  annotation = annotation data ('N' = normal, other are types of
%    anomalies) of each beat
%  time = timing data (maps annotations to signal)
%  header = header data (struct)
%  ecg = helper struct, contains all the fields above grouped together.

headerFile = fullfile(pathDB,[fileName '.hea']);
headerData = readheader(headerFile);
 
dataFile = fullfile(pathDB,[fileName '.dat']);
EKG_raw = rdsign212(dataFile,headerData.nsig,1,headerData.nsamp);

annotFile = fullfile(pathDB,[fileName '.atr']);
ANN = readannot(annotFile,[1 headerData.nsamp]);

% annotFile = fullfile(pathDB,[fileName '.man']);
% ANN = readannot(annotFile,[1 headerData.nsamp]);
% annotFile = fullfile(pathDB,[fileName '.pu']);
% ANN1 = readannot(annotFile,[1 headerData.nsamp]);
% annotFile = fullfile(pathDB,[fileName '.qt1']);
% ANN2 = readannot(annotFile,[1 headerData.nsamp]);
% annotFile = fullfile(pathDB,[fileName '.pu1']);
% ANN3 = readannot(annotFile,[1 headerData.nsamp]);

% simplify returned data:
signal = EKG_raw(:,1);
annotation = ANN.anntyp;
time = ANN.time;
header = headerData;

ecg = {};
ecg.signal = signal;
ecg.annot = annotation;
ecg.times = time;
ecg.header = header;
