function ecgCut = subsampleECG(ecgStruct, range)
%% subsampleECG - cut a sub-sample from ECG signal, along with annotation & timing
% params:
%   ecgStruct = ECG in structure provided by readECTSamplePhysionet as
%               'ecg' field.
%   range = [min, max] list
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
  signal=signal(r0:r1);
  mask = (time>=r0 & time <= r1);
  annot=annot(mask);
  annotT=time(mask);
 
  ecgCut={};
  ecgCut.signal = signal;
  ecgCut.times = annotT;
  ecgCut.annot = annot;
  ecgCut.header = ecgStruct.header;