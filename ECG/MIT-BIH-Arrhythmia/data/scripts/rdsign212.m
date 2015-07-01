% function sig=rdsign212(namefile,nsig,tonset,toffset)
% This function reads binary ECG data files with format 212
% Input parameters:
%    namefile: string [with the whole path] to the annotation file
%    nsig: integer with the number of channels in the data file
%    tonset: positive integer with the first sample to read
%    toffset: positive integer with the last sample to read
% Output parameters:
%    sig: ECG signal vector with the ECG signal in different columns

