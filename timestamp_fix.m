%% Grant Livingston
% Created: 5/20/15
% Last Modified: 2/2/2016 Chris Conatser

% Purpose: Function to fix all of the missing timesteps in DataTable.csv

% Input: DataTable variable obtained using readtable(DataTable.csv)
        
% Output: DataTable_tfix.csv
%%

function DataTable_tfix = timestamp_fix(DataTable)

%The first time - used to make the rest of the T_corrected vector.
T_corrected(1) = datenum('08/14/14 14:00:00');
T = datenum(DataTable.Time);            %Serial time vector

%lengthT is the length of the fixed timestamp vector
%widthT is the number of variables in the data table, including time (table width)
lengthT = round((datenum(DataTable.Time(end))-T_corrected)/0.0104166667 + 1);
widthT = length(DataTable.Properties.VariableNames);

%Makes a vector with all of the correct timestamps (using matlab time)
T_corrected(2:lengthT) = NaN; %initialize variable
for ii = 2:lengthT;
T_corrected(ii) = T_corrected(ii-1)+ 0.0104166667; %This number is the closest number to 15 that I can find due to roundoff errors.
end
T_corrected = T_corrected';             %flips the rows and colums

%%
%Make a new matrix that has the numerical data (not the timestamp)
%from DataTable
lgr_num = table2array(DataTable(:,2:end));

%%
%-----------Now make the corrected DataTable matrix: lgr_tfix-----------
%Description:
%This first makes a blank matrix,lgr_tfix, then it puts the 
%timestamp into it, then it fills out the rest of the lgr_tfix 
%with the data from DataTable

%Initialize variables
lgr_tfix = NaN(lengthT,widthT);         % Initialize matrix
lgr_tfix(:,1) = T_corrected;            % Put the corrected time into lgr_tfix

%The Loop:
%Need to have 2 indexes for the 2 different matrices
%jj is the corrected matrix. ii is the "old" matrix

jj=1; 
for ii = 1:length(T);
     
    %Compare the "old" timestamp with the corrected timestamp.
    %If the difference is greater than the threshold of 6 minutes,
    %then it fills in the lgr_tfix with NaNs. 
    while (T(ii)- T_corrected(jj)) > (1/24/60*6) %6 minutes in matlab time

        lgr_tfix(jj,2:widthT) = NaN;
        jj = jj+1;                      %Increment time until they agree.
       
       if jj >= lengthT                 %Just in case j gets too big, this breaks the loop
            break
       end
    end
    
    %If the corrected and old timestamp agree, then
    %the "old" data is moved into lgr_tfix
    if jj <= lengthT %this "if" is just to make sure j doesn't go beyond the length
        %of the dataset. 
        
    lgr_tfix(jj,2:end) = lgr_num(ii,1:end);
    jj = jj+1;
    
    end
    
end
%%

DataTable_tfix = array2table(lgr_tfix,...
    'VariableNames',DataTable.Properties.VariableNames);
DataTable_tfix.Time = cellstr(datestr(DataTable_tfix.Time,31));

%Clear all old variables
clear ans ii jj lengthT widthT lgr_num lgr_tfix T T_corrected

%Make a hard-copy, csv file. 
writetable(DataTable_tfix,'Processing/DataTable_tfix.csv') 

