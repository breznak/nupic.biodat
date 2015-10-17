function ecgCut = subsampleECG(ecg, rangeStart, rangeEnd, category)
%% subsampleECG - cut a sub-sample from ECG signal, along with annotation & timing
% params:
%   ecgStruct = ECG in structure provided by readECTSamplePhysionet as
%               'ecg' field.
%   rangeStart, rangeEnd - which step from the signal to cut, inclusive
%                          both
%   category = char, as for annot; but defines "category of the subsample",
%              for example, if you make a subsample of a Ventricular
%              anomaly, the annotation would be 'NNNVN', and category =
%              'VVVVV'.
% return:
%   ecgCut = the sub sample, signal from min to max, as well as modified
%            annot & timings, etc.
  r0=rangeStart;
  r1=rangeEnd;
  %hz=360;
  
  signal = ecg.signal;
  time = ecg.times;
  
  % crop
  signalC=signal(r0:r1); %cropped signal
  maskT = (time>=r0 & time <= r1);
  timeC = time(maskT); % cropped time
  annotC = ecg.annot(r0:r1);
  stepsC = ecg.steps(r0:r1);
  idC = ecg.id(r0:r1);
  
  ecgCut=ecg;
  ecgCut.signal = signalC;
  ecgCut.steps = r0:1:r1; % used for sub-samples
  ecgCut.times = timeC';
  ecgCut.annot = annotC;
  ecgCut.category = char(ones(1, (r1-r0+1))*category);
  ecgCut.id = idC;
  ecgCut.steps = stepsC;