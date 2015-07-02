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
