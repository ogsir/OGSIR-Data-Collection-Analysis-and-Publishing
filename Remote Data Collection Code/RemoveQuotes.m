% Chris Conatser
% 8/12/2015
% After Jan Simon, http://www.mathworks.com/matlabcentral/answers/51399-replace-comma-by-dot
%
%
% Use this code snip to remove extraneous quotation marks from a .csv file 
% so that it can be read properly into Matlab using csvread.

DataTableReplace = fileread('DataTable1.csv');
DataTableReplace = strrep(DataTableReplace, '"', '');
FID = fopen('DataTableReplacement.csv', 'w');
fwrite(FID, DataTableReplace, 'char');
fclose(FID);