clear all; close all; clc;
%%
% hledat N vs V  z ANN.anntype
% vyhodit PACED lidi
% BBB jsou jako V ale v jiny cas
% physiobank MIT-BIH

clc; clear; close all

[sig, ann, tim, header, ecg] = readECGSamplePhysionet('100', '../mitdb');

% preprocess
plotECG(tim, sig, ann)
title('orig ECG')

% downsample Nx
figure
sub = subsampleECG(ecg, [1, 1000]);
plotECG(sub.times, sub.signal, sub.annot)
