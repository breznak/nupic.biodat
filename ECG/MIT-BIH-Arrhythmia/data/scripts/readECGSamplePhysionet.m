function [signal, annotation, time, header, ecg] = readECGSamplePhysionet(fileName, pathDB)
%% readECGSamplePhysionet
% this function loads data from MIT-BIH database of ECG [1]
% params:
%  fileName = name of file (without suffix, eg '100')
%  pathDBDB = pat to the database, eg '~/mydata/mitdb/'
% returns:
%  signal = the ECG signal, 360Hz sampling, 10mV 
%TODO what is signal 2?
%  steps = which steps is this signal from? (eg 1:650k)
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
% id = name of the file = patient
id=str2num(fileName);

len = size(signal,1);
ecg = {};
ecg.signal = signal'; % signal (ECG)
ecg.steps = 1:1:len; 
ecg.id = ones(1, len)*id; % name of the pacient
ecg.annot = char(ones(1,len)*'N'); % default all 'N's (normal)
ecg.annot(time) = annotation; % assign annotated labels to given times
% category: used by subsample(), similar to annot, but same for all fields;
% eg if annot is 'NNNVN', category = 'VVVVV'
ecg.category = char(ones(1,len)*'N'); % default all 'N's (normal)
ecg.times = time;
ecg.ANN_=ANN; % orig annotation data (all)
ecg.ECG_raw_ = EKG_raw(:,:); % orig all ECG data 
ecg.header = header;
