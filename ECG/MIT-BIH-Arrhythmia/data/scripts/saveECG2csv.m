function saveECG2csv(name, ecg)
%% save ECG signal as CSV file
% for processing eg. by NuPIC
% File format, see: https://github.com/numenta/nupic/wiki/NuPIC-Input-Data-File-Format
% params:
%   ecg - ECG in struct obtained by readECGSamplePhysionet() or subsample()
%   name - new file name
f = fopen(name, 'w');
% header definition
headerNames='sequenceId,ecg,annotStr,annotCls';
headerTypes='string,int,string,int';
headerMeta='S,,,';

seqId=num2str(ecg.header.recname);
defaultAnnot='N';

% write header
fprintf(f, '%s\n', headerNames);
fprintf(f, '%s\n', headerTypes);
fprintf(f, '%s\n', headerMeta);

for i = 1:size(ecg.signal,1)
  % write data
  rowFormat = '%s,%i,%s,%i\n';
  ecgSignal = ecg.signal(i);
  annotStr = defaultAnnot;
  if any(i == ecg.times)
    annotStr = ecg.annot(i)
  end
  annotCls = annotStr ~= defaultAnnot;

  fprintf(f, rowFormat, seqId, ecgSignal, annotStr, annotCls);
end