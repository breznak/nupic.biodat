% function ann=readannot(namefile,time)
% This function reads annotation files from MIT annotation files
% Input parameters:
%    namefile: string [with the whole path] to the annotation file
%    time: [onset offset]  vector of 2 elements with the time interval
% Output parameters:
%    ann: struct with the annotation information {time,anntyp,subtyp,chan,num,aux}

