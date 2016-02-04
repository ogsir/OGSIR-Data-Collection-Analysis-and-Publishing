%Grant Livingston
%Created 5/7/15
%Modified 5/20/15
%Debugged 12/19/15

%Inputs:
    %lgrall_tfix.csv. It gets renamed here to "lgr" for ease of use. 
            lgr = lgrall_tfix;

%Outputs:
    %lgr - after all the sensor issues have been applied
    %h_sedbay - after all the sensor issues (not including drift correction are
    %fixed.

    
    
%Purpose: 
%   1. Correct all of the issues with lgr_all.csv. 
    %including:
        %1. Sensor wiring changes
        %2. Sensor location changes

        %For a full list of issues refer to "lgr metadata - update when lgr or
        %lgr2 is updated.txt" located in Dropbox\Data and "Stormwater Facility Notes"
        %located on Google Drive. 

%   2. Collect inflow head data from lgr, h_sedbay, and fix issues due to sensor fails
    
%Needed:  
    
    %Must also import CTD_matlab.xlsx as column vectors using the import wizards, which is the CTD data used to replace
    %the SDXPress1 data when it was down. 
    %Also need to run code below for time array
%%

figure(1)
subplot(3,1,1)
plot(T,lgrall_tfix.SDXPress1)
datetick('x')
title('Raw SDXPress1 Data with Timestamp Fix')
ylabel('Water Depth, (ft)')

%--------Start Issue 1: SDXPress1 and SDXPress2 Wiring Change-------
%Note that at one point during this project, the SDXPress1
%And the SDXPress2 had their wires changes in the port in the 
%CR1000. So this file fixes that issues.

%Wiring change occured between 2/26/15 11:45 and 4/4/15 10:45 

%Make the bounds for the fix
s = find(strcmpi('2015-02-26 11:45:00',lgr.Time));
e = find(strcmpi('2015-04-04 10:45:00',lgr.Time));

%Implement the fix
%SDXPress1 and SDXPress2 had the wiring switched in this time period.
temp5 = lgr.SDXPress5(s:e);
temp6 = lgr.SDXPress6(s:e);

lgr.SDXPress5(s:e) = temp6;
lgr.SDXPress6(s:e) = temp5;

clear s e temp5 and temp6

%--------End Issue 1: SDXPress1 and SDXPress2 Wiring Change-------
%%
%
%%
%--------Start Issue 2: SDXPress5 data replaced with SDXPress6 Data-------
%
%SDXPress6 sensor from Cell 1 Outlet was moved to Cell 2 outlet. 
%SDXPress5 data not valid from 4/9/15 20:00 to present (5/15/15).

%Make the bounds for the fix
s = find(strcmpi('2015-04-09 20:00:00',lgr.Time));
e = length(lgr.Time);

%Implement the fix
%SDXPress5data replaced with SDXPress6 data
lgr.SDXPress5(s:e) = lgr.SDXPress6(s:e);

clear s e


%--------End Issue 2: SDXPress5 data replaced with SDXPress6 Data-------
%%
%
%%
%--------Start Issue 3: SDXPress1 data replaced Decagon CTD Data-------
 
%Make the bounds for the fix
time1 = '2015-02-26 10:30:00' % time_CTD(1); %2015-02-26 10:30:00
time1 = cellstr(datestr(datenum(time1),31));
s = find(strcmpi(time1,lgr.Time));
clear time1

time_end = '2015-04-09 16:00:00' % time_CTD(end); %4/9/2015 4:00:00 PM
time_end = cellstr(datestr(datenum(time_end),31));
e = find(strcmpi(time_end,lgr.Time));
clear time_end

%Implement the fix

lgr.SDXPress1(s:e) = CTD_depth_ft;

clear s e 

subplot(3,1,2)
%s = 18803
%e = 22857
plot(T,lgr.SDXPress1)
datetick('x')
title('Decagon CTD Data Replaced SDXPress1 Data 2/26/15 to 4/9/15')
ylabel('Water Depth, (ft)')


%--------End Issue 3: SDXPress1 data replaced Decagon CTD Data-------
%%

%%
%--------Start Issue 4: SDXPress1 new 2.5ft sensor and CR1000 fix-------
%The CR1000 code initially did not deal with the 2.5ft sensor properly.
%This will fix the issue. 

%Make the bounds for the fix
s = find(strcmpi('2015-04-09 16:15:00',lgr.Time));
e = find(strcmpi('2015-04-22 09:30:00',lgr.Time));

%Implement the fix
%See SDXPress1_2.5ft.xlsx for more details about how the fix works.

%Convert 5ft depth range data back to milivolts
mvolt = (lgr.SDXPress1(s:e)+1.247655)/0.00125; %mV

%Convert milivolts to depth on 2.5ft range
lgr2_5 = 0.000625.*mvolt-0.625; %ft

%Copy fixed data back into lgr
lgr.SDXPress1(s:e) = lgr2_5;
clear s e mvolt lgr2_5

subplot(3,1,3)
%s = 22858
%e = 24079
plot(T,lgr.SDXPress1)
datetick('x')
title('SDXPress1 2.5ft SDX Range Fixed for 4/9/15 to 4/22/15')
ylabel('Water Depth, (ft)')
xlabel('Time')

%--------End Issue 4: SDXPress1 new 2.5ft sensor and CR1000 fix-------
%
%%Make a hard copy of lgr so you don't have to do this process again. 
%writetable(lgr,'lgr_fix.csv') 
%
%
%%
%-------Start Issue 5: Sediment Bay Sensor Issues------------------------------------
%-----------**PRELIMINARY DATA FIXES
%Collect data from lgr
h_sedbay = lgr.SDXPress1;

%%%--Sensor Fails - Caused nonsensicle data and are deleted here
%
%Remove bad data before all sensors worked. All sensors went live on 10/21/14
e = find(strcmpi('2014-10-21 14:30:00',lgr.Time)); %lookup table version of matlab
h_sedbay(1:e) = NaN; %Make all values up to and including 10/21 14:30 a NaN because no other sensors were
                     %working at this time due to bad program in CR1000. 

%Remove bad data from when the SDXPress1 failed. 
%1/22/15 19:45 to 2/26/15 10:15am. We have no good sediment bay data for this time period. 
%Decagon CTD is used starting at 10:30 am on 2/26/15, and was already fixed in sensor_CR1000_issue_fix.m
s = find(strcmpi('2015-01-22 19:45:00',lgr.Time)); %start of fix
e = find(strcmpi('2015-02-26 10:15:00',lgr.Time)); %end of fix
h_sedbay(s:e) = NaN; %All of this data is non-sensical and should not be used.
%%%--
%
%
%%%--Other Errors - Caused few NaNs and are interpolated here
%
%Interpolate the remainder of h_sedbay NaNs (minor CR1000 failures - there
%are very few of them, and they generally effect less than 3 time steps at a
%time. 

%First segment of data
s = find(strcmpi('2014-10-21 14:45:00',lgr.Time));
e = find(strcmpi('2015-01-22 19:30:00',lgr.Time)); 

%inpaint_nans is a sweet interpolation tool. 
h_sedbay(s:e) = inpaint_nans(h_sedbay(s:e));

%second segment of data
s = find(strcmpi('2015-02-26 10:30:00',lgr.Time));
e = length(lgr.Time);

%inpaint_nans is a sweet interpolation tool.
h_sedbay(s:e) = inpaint_nans(h_sedbay(s:e));
%%%--
%%---------*****************************************************
%%-------End Issue 5: Sediment Bay Sensor Issues------------------------------------
%
%
%%-------Start Issue 6: SDXPress4 Issues (Cell 3)------------------------------------
%Cell 3 Data is collected on the SDXPress4 CR1000 Port

%Initialize h_out3
h_out3 = lgr.SDXPress4;

% h_weir3 = 1.587927; %ft, physically measured, but not practical to apply

%Remove all bad data up to and including 10/21/14 at 14:30 because CR1000
%was not working properly until the first timestep after this. 
e = find(strcmpi('2014-10-21 14:30:00',lgr.Time));
h_out3(1:e) = NaN;              

%first part of data
s = find(strcmpi('2015-01-22 19:45:00',lgr.Time)); %start of fix
e = find(strcmpi('2015-02-26 10:15:00',lgr.Time)); %end of fix
h_out3(s:e) = NaN; %All of this data should not be used because SDXPress1 was not yet working


%Interpolate the rest of h_out3 to remove NaNs (there are very few of them)
    %2nd part of data
    s = find(strcmpi('2014-10-21 14:45:00',lgr.Time));
    e = find(strcmpi('2015-01-22 19:30:00',lgr.Time));

    %inpaint_nans is a sweet interpolation tool
    h_out3(s:e) = inpaint_nans(h_out3(s:e)); 

    %3rd part of data
    s = find(strcmpi('2015-02-26 10:30:00',lgr.Time));
    e = length(lgr.Time);

    %inpaint_nans is a sweet interpolation tool
    h_out3(s:e) = inpaint_nans(h_out3(s:e));
%

%%-------End Issue 6: SDXPress4 Issues (Cell 3)------------------------------------



%clear out the variables that are not used. 
clear time_CTD CTD_depth_ft lgrall_tfix ans

   
%How to do a lookup table in Matlab
%lookupIndices = find(strcmpi('FIND THIS STRING',lookupArray(:));
%'FIND THIS STRING' is a string to find in lookupArray, which is cell-array 
%containing strings. The strcmpi() function returns a column vector 
%containing booleans indicating which elements in the lookupArray match 
%the desired string; finally, the find() function finds the indices of the
%nonzero elements in aforesaid boolean vector.