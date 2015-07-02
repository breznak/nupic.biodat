function ecgCut = subsampleECG(ecgStruct, range)
%% subsampleECG - cut a sub-sample from ECG signal, along with annotation & timing
% params:
%   ecgStruct = ECG in structure provided by readECTSamplePhysionet as
%               'ecg' field.
%   range = [min, max] list of steps (1..650k)
% return:
%   ecgCut = the sub sample, signal from min to max, as well as modified
%            annot & timings
  r0=range(1);
  r1=range(2);
  hz=360;
  
  signal = ecgStruct.signal;
  time = ecgStruct.times;
  annot = ecgStruct.annot;
  
  % crop
  signalC=signal(r0:r1); %cropped signal
  len = size(signalC, 1);
  maskT = (time>=r0 & time <= r1);
  timeC = time(maskT); % cropped time
  annotC=char(ones(1, len)*'N')
  annotS = annot(timeC); % cropped annot (sparse)
  annotC(timeC)=annotS;
 
  ecgCut=ecgStruct;
  ecgCut.signal = signalC;
  ecgCut.steps = r0:1:r1; % used for sub-samples
  ecgCut.times = timeC;
  ecgCut.annot = annotC;
  ecgCut.header = ecgStruct.header;