%Grant Livingston
%Created: 5/20/15
%Modified: 5/20/15
%Purpose:
%Used to import all raw lgr data.



%% Import data from text file.
% Script for importing data from the following text file:
%
%    E:\Dropbox\Data\lgr_all.csv
%
% To extend the code to different selected data or a different text file,
% generate a function instead of a script.

% Auto-generated by MATLAB on 2015/05/20 12:33:41

%% Initialize variables.
filename = 'C:\Users\Grant\Dropbox\Publication\Matlab\Data\lgr_all.csv'; %Grant Home Computer
%filename = 'E:\Dropbox\Data\lgr_all.csv'; %Grant Work Computer
delimiter = ',';
startRow = 2;

%% Format string for each line of text:
%   column1: text (%s)
%	column2: double (%f)
%   column3: double (%f)
%	column4: double (%f)
%   column5: double (%f)
%	column6: double (%f)
%   column7: double (%f)
%	column8: double (%f)
%   column9: double (%f)
%	column10: double (%f)
%   column11: double (%f)
%	column12: double (%f)
%   column13: double (%f)
%	column14: double (%f)
%   column15: double (%f)
%	column16: double (%f)
%   column17: double (%f)
%	column18: double (%f)
%   column19: double (%f)
%	column20: double (%f)
%   column21: double (%f)
%	column22: double (%f)
%   column23: double (%f)
%	column24: double (%f)
%   column25: double (%f)
%	column26: double (%f)
%   column27: double (%f)
%	column28: double (%f)
%   column29: double (%f)
%	column30: double (%f)
%   column31: double (%f)
%	column32: double (%f)
%   column33: double (%f)
%	column34: double (%f)
%   column35: double (%f)
%	column36: double (%f)
%   column37: double (%f)
%	column38: double (%f)
%   column39: double (%f)
%	column40: double (%f)
%   column41: double (%f)
%	column42: double (%f)
%   column43: double (%f)
%	column44: double (%f)
%   column45: double (%f)
%	column46: double (%f)
%   column47: double (%f)
%	column48: double (%f)
%   column49: double (%f)
%	column50: double (%f)
%   column51: double (%f)
%	column52: double (%f)
%   column53: double (%f)
%	column54: double (%f)
%   column55: double (%f)
%	column56: double (%f)
%   column57: double (%f)
%	column58: double (%f)
%   column59: double (%f)
%	column60: double (%f)
%   column61: double (%f)
%	column62: double (%f)
%   column63: double (%f)
%	column64: double (%f)
%   column65: double (%f)
%	column66: double (%f)
%   column67: double (%f)
%	column68: double (%f)
%   column69: double (%f)
%	column70: double (%f)
%   column71: double (%f)
%	column72: double (%f)
%   column73: double (%f)
%	column74: double (%f)
%   column75: double (%f)
%	column76: double (%f)
%   column77: double (%f)
%	column78: double (%f)
%   column79: double (%f)
%	column80: double (%f)
%   column81: double (%f)
%	column82: double (%f)
%   column83: double (%f)
%	column84: double (%f)
%   column85: double (%f)
%	column86: double (%f)
%   column87: double (%f)
%	column88: double (%f)
%   column89: double (%f)
%	column90: double (%f)
%   column91: double (%f)
% For more information, see the TEXTSCAN documentation.
formatSpec = '%s%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%[^\n\r]';

%% Open the text file.
fileID = fopen(filename,'r');

%% Read columns of data according to format string.
% This call is based on the structure of the file used to generate this
% code. If an error occurs for a different file, try regenerating the code
% from the Import Tool.
dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'EmptyValue' ,NaN,'HeaderLines' ,startRow-1, 'ReturnOnError', false);

%% Close the text file.
fclose(fileID);

%% Post processing for unimportable data.
% No unimportable data rules were applied during the import, so no post
% processing code is included. To generate code which works for
% unimportable data, select unimportable cells in a file and regenerate the
% script.

%% Create output variable
lgrall = table(dataArray{1:end-1}, 'VariableNames', {'Time','Int','SDXPress1','SDXPress2','SDXPress3','SDXPress4','SDXPress5','SDXPress6','NetRad_Wm2','Moisture1','EC1','Temperature1','Moisture2','EC2','Temperature2','Moisture3','EC3','Temperature3','Moisture4','EC4','Temperature4','Moisture5','EC5','Temperature5','Moisture6','EC6','Temperature6','Moisture7','EC7','Temperature7','Moisture8','EC8','Temperature8','Moisture9','EC9','Temperature9','Moisture10','EC10','Temperature10','Moisture11','EC11','Temperature11','Moisture12','EC12','Temperature12','Moisture13','EC13','Temperature13','Moisture14','EC14','Temperature14','Moisture15','EC15','Temperature15','Moisture16','EC16','Temperature16','Moisture17','EC17','Temperature17','Moisture18','EC18','Temperature18','Moisture19','EC19','Temperature19','Moisture20','EC20','Temperature20','Temp1','pF1','Temp2','pF2','Temp3','pF3','Temp4','pF4','Temp5','pF5','Temp6','pF6','Temp7','pF7','Temp8','pF8','WndSpd','WndDir','AirTmp','RelHum','BarPress','Rain'});

%% Clear temporary variables
clearvars filename delimiter startRow formatSpec fileID dataArray ans;