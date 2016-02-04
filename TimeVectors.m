%% Grant Livingston
% Created 1/26/15
% Last Modified 2/2/2016 Chris Conatser

% Purpose: Make the vectors T (serial time) and t (integer time)
 
function [T, t] = cattime_v2(DataTable_tfix)
%% Convert time to Serial Time
T = datenum(DataTable_tfix.Time);
%Convert time to Julian Time
%T = T - (datenum('2014-01-01 00:00:00','yyyy-mm-dd HH:MM:SS')-1); %1/1/2014 is day 1, 1/2/2014 is day 2, etc. 
%Also have integer time for plotting purposes
t = (1:size(DataTable_tfix.Time))';

