%%
% hledat N vs V  z ANN.anntype
% vyhodit PACED lidi
% BBB jsou jako V ale v jiny cas
% physiobank MIT-BIH

clc; clear; close all
EXPERIMENT_PATH='../../model';
%% example on 1 patient


% load data for patient (file) 100
[sig, ann, tim, header, ecg] = readECGSamplePhysionet('100', '../mitdb');
ecg 

% plot whole ECG, show all anomalies
figure()
plotECG(ecg, 'n')
title('orig ECG with all anomalies')

% plot whole ECG, show all anomalies
figure()
plotECG(ecg, 'V')
title('orig ECG with Ventricular anomalies')


% demo
figure()
demo = subsampleECG(ecg, [10000, 15000])
plotECG(demo, 'n')


% preprocess
% TODO

% subsample of interesting part
figure(8)
sub = subsampleECG(ecg, [540000, 550000]); % interesting region - 'V' type anomaly
plotECG(sub, 'n')

% zoom
figure
zoom = subsampleECG(ecg, [3.02*10^5, 3.08*10^5]);
plotECG(zoom, 'V')

% save data in NuPIC OPF format
saveECG2csv('../out.csv', sub)

% process in NuPIC
% you may need to edit model/swarm/description.py etc
!$NUPIC/scripts/run_opf_experiment.py ../../model/swarm
!../../model/format_output.sh > ../../model/results.txt

%% load results back
res = loadResultsFromCSV('results.csv');
an = res(:,3);
act = res(:,2);
pred = res(:,4);

%% interpret results
figure(8)
plot(sub.steps, act)
hold all
plot(sub.steps, pred)
plot(sub.steps, an*800)
title('NuPIC anomaly results')

%% evaluate on test-set (non-trained) sample(s)
[~,~,~,~, ecg] = readECGSamplePhysionet('102', '../mitdb');

% plot whole ECG
plotECG(ecg, 'n')
title('orig ECG')
% cut 
figure
sub = subsampleECG(ecg, [25000, 36000]); % interesting region - 'V' type anomaly
plotECG(sub, 'V')

% store
saveECG2csv('../out.csv', sub)



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
    figure
    plotECG(ecg, 'n')
%    plot(ecg.signal)
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

% save
saveECG2csv('../out.csv', sigAll)
