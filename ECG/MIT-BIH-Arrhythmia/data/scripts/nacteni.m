%%
% hledat N vs V  z ANN.anntype
% vyhodit PACED lidi
% BBB jsou jako V ale v jiny cas
% physiobank MIT-BIH

clc; clear; close all
EXPERIMENT_PATH='../../model';
%% example on 1 patient


% load data
[sig, ann, tim, header, ecg] = readECGSamplePhysionet('100', '../mitdb');

% plot whole ECG
plotECG(ecg)
title('orig ECG')

% preprocess
% TODO

% subsample of interesting part
figure
sub = subsampleECG(ecg, [200000, 350000]); % interesting region - first normal, later lot anomalies
plotECG(sub)

% zoom
figure
zoom = subsampleECG(ecg, [3.02*10^5, 3.08*10^5]);
plotECG(zoom)

% save data in NuPIC OPF format
saveECG2csv('../out.csv', sub)

% process in NuPIC
% you may need to edit model/swarm/description.py etc
!$NUPIC/scripts/run_opf_experiment.py ../../model/swarm
!../../model/format_output.sh > ../../model/results.txt

%% load results back
res = importfile('../../model/resutls.csv');

% interpret results


%% whole dataset
clc; clear; close all

% read all data
allNames = [100:124 200:234];
% remove missing names. Why they name it like this? :P
missing=[110 120 204 206 211 216 218 224:227 229]';
for idx = 1:numel(missing)
  allNames(allNames==missing(idx))=[];
end

figure
hold all
sigAll=[];
for n = 1:numel(allNames)
    name = num2str(allNames(n));
    [~, ~, ~,~, ecg]=readECGSamplePhysionet(name, '../mitdb');
%    plotECG(ecg)
    plot(ecg.signal)
    sigAll = [sigAll; ecg.signal];
end
title('All samples overlaped')

figure
plot(sigAll)
title('All samples in sequence')

%some stats
aMin = min(sigAll)
aMax = max(sigAll)
aMean = mean(sigAll)

