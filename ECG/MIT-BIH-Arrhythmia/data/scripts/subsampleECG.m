function ecgCut = subsampleECG(ecgStruct, range)
%% subsampleECG - cut a sub-sample from ECG signal, along with annotation & timing
% params:
%   ecgStruct = ECG in structure provided by readECTSamplePhysionet as
%               'ecg' field.
%   range = [min, max] list of steps (1..650k)
% return:
%   ecgCut = the sub sample, signal from min to max, as well as modified
%            annot & timings, etc.
  r0=range(1);
  r1=range(2);
  %hz=360;
  
  signal = ecgStruct.signal;
  time = ecgStruct.times;
  
  % crop
  signalC=signal(r0:r1); %cropped signal
  maskT = (time>=r0 & time <= r1);
  timeC = time(maskT); % cropped time
  annotC = ecgStruct.annot(r0:r1);
  stepsC = ecgStruct.steps(r0:r1);
  idC = ecgStruct.id(r0:r1);
  
  ecgCut=ecgStruct;
  ecgCut.signal = signalC;
  ecgCut.steps = r0:1:r1; % used for sub-samples
  ecgCut.times = timeC';
  ecgCut.annot = annotC;
  ecgCut.id = idC;
  ecgCut.steps = stepsC;