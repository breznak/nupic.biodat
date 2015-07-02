clear all; close all; clc;
%%
% hledat N vs V  z ANN.anntype
% vyhodit PACED lidi
% BBB jsou jako V ale v jiny cas
% physiobank MIT-BIH

clc; clear; close all

%% example on 1 patient

% load data
[sig, ann, tim, header, ecg] = readECGSamplePhysionet('100', '../mitdb');
ecg 

% whole ECG
%plotECG(ecg)
%title('orig ECG')

% demo
demo = subsampleECG(ecg, [10000, 15000])
plotECG(demo)
return

% subsample of interesting part
figure
sub = subsampleECG(ecg, [200000, 350000]); % interesting region - first normal, later lot anomalies
plotECG(sub)

% zoom
figure
zoom = subsampleECG(ecg, [3.02*10^5, 3.08*10^5]);
plotECG(zoom)


