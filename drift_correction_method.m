%Grant Livingston
%Purpose: Find datums for drift correction

%Description: This is the drift correction method, which allows the user to
%find all of the sensor datums. The datum drift was observed to occur
%randomly over time.  The following visualization tools help the user to
%recognize and record stable periods of sensor data during which a datum
%could be deduced from water level.  This is all based on the assumption
%that when the water drains, it drains to the bottom of the vee, then it
%holds at a relatively constant level for several hours. 

%Created 4/21/15
%Modified 4/21/15
%Debugged 12/19/15,1/15/16,1/29/16


%There are 2 sections of code below, one for SDXPress 1 (sediment bay, and
%one for SDX Press 4 (Cell 3). They must be run separately, 1 section at a
%time. 

%The Datum Fix folder is located in the Error Analysis folder.
%However, the method could be improved. 
%It is currently slow, and it requires lots of manual graphical
%analysis (days of time to complete...). 


%%
%%%--------Start Drift Correction for SDXPress1 (Sediment Bay)-------------
% 
%INPUTS: 
    %h_sedbay variable.
    %Datum_Fix_Summary.xlsx will also need to be open in Excel for pasting
    %information into. 

%OUTPUTS:
    %h_sedbay_datums_ranges.xlsx 
    
%
%% 
%%%%%---FIND DATUM RANGES (locations where water is at bottom of v-notch)
%%
%
%Use this plot to find datum intervals. Manually enter them (coarse)
%into Excel in Datum_Fix_Summary.xlsx

%HINT: Use pan and zoom tools. 

%First time data is good is 10/21/14 at 14:45
s = find(strcmpi('2014-10-21 14:45:00',lgr.Time));
l = length(lgr.Time); 

%672 is number of timesteps in a week, 960 for 10 days. 700 is a 
%good number of timesteps to view in 1 window while searching
%for datums. 
for i = s:700:l 
    s = i; e = i+700;
figure(1)
[AX,H1,H2] = plotyy(t,h_sedbay,t,rain.P,'plot','bar');
%The h_sedbay and rain data are used here because the inflow peaks are
%dependent on the precipitation

set(get(AX(1),'Ylabel'),'String','SDX Measurement (ft)')
set(get(AX(2),'Ylabel'),'String','Precipitation (mm/15min)')
set(get(AX(1),'Xlabel'),'String','Time')

set(AX(1),'YLim',[0.6,0.9],'xlim',[s e])
set(AX(1),'YTick', [0.6:0.01:0.9]);

set(AX(2),'YLim',[0,2],'xlim',[s e])
set(AX(2),'YTick',[0:0.25:2]);

title('Sediment Bay Water Depth and Precipitation');
legend([H1,H2],'SB Water Depth','Rain')

set(H1,'Marker','o','MarkerSize',3)
grid minor
grid on

datetick('x',1,'keeplimits')

pause
end

clear H1 H2 AX i l s e

%
%At this stage, you should have recorded all of the datums and
%ranges for h_sedbay in  Datum_Fix_Summary.xlsx. Copy the fine datum ranges
%from Datum_Fix_Summary.xlsx into h_sedbay_datums_ranges.xlsx. 
%
%%
%Import all of the selected datum intervals as column vectors using import wizard from h_sedbay_datums_ranges.xlsx,
%and find the mean of each datum interval with this "for" loop.
%
%
for i = 1:length(h_sedbay_datum_fix_start)
    h_sedbay_datums(i) = mean(h_sedbay(h_sedbay_datum_fix_start(i):h_sedbay_datum_fix_end(i)));
    hold on
    plot(h_sedbay(h_sedbay_datum_fix_start(i):h_sedbay_datum_fix_end(i)));
end
%
%
%plot Datums
xlabel('# Points used for h-in Datums')
ylabel('Datum (ft)')
title('Plot of all datums used for drift fix of Sediment Bay SDX')
%
%Flip matrix to be in easy direction for copy and paste into Excel
h_sedbay_datums = h_sedbay_datums';
%
%Paste h_sedbay_datums generated from this "for" loop into
%the Excel file h_sedbay_apply.xlsx This excel file contains 3 columns: 2 with the applicable datum ranges and 1 with the datums. 
%
%
%%%--------------End Drift Correction Method for SDXPress1 (Sed Bay)-------------
%
%
%
%
%%
%%%----------------Start Drift Correction Method for SDXPress4 (Cell 3)---------------
%
%INPUTS: 
    %h_out3 variable.
    %Datum_Fix_Summary.xlsx will also need to be open in Excel for pasting
    %information into. 
       
%OUTPUTS:
    %h_out3_datums_ranges.xlsx 
    %h_out3_apply.xlsx
    
%
%% 
%%%%%FIND DATUM RANGES (locations where water is at bottom of v-notch)
%%
%
%Use this plot to find datum intervals. Manually enter them (coarse)
%into Excel in Datum_Fix_Summary.xlsx

%HINT: Use pan and zoom tools. 

%First time data is good is 10/21/14 at 14:45
s = find(strcmpi('2014-10-21 14:45:00',lgr.Time)); %First time data is good is 10/21/14 at 14:45
l = length(lgr.Time); 

%672 is number of timesteps in a week, 960 for 10 days. 700 is a 
%good number of timesteps to view in 1 window while searching
%for datums. 
for i = s:700:l
    s = i; e = i+700;
figure(1)
[AX,H1,H2] = plotyy(t,h_out3,t,h_sedbay,'plot','plot');
%The h_out3 and h_sedbay are used here because the outflow peaks are
%dependent on the inflow peaks


set(get(AX(1),'Ylabel'),'String','Cell 3 Stilling Well Measurement (ft)')
set(get(AX(2),'Ylabel'),'String','Sediment Bay Water Level (ft))')
set(get(AX(1),'Xlabel'),'String','Time')

set(AX(1),'YLim',[1.52,1.72],'xlim',[s e]);
set(AX(1),'YTick',[1.52:0.01:1.72]);

set(AX(2),'YLim',[0.75,2],'xlim',[s e]);
set(AX(2),'YTick',[0.75:0.1:2]);

title('Cell 3 Water Depth and Sediment Bay Water Depth');
legend([H1,H2],'h_o_u_t_3','h_s_e_d_b_a_y')

set(H1,'Marker','o','MarkerSize',3)
grid minor
grid on

datetick('x',1,'keeplimits')

pause
end

clear H1 H2 AX i l s e

%
%At this stage, you should have recorded all of the datums and
%ranges for h_sedbay in  Datum_Fix_Summary.xlsx. Copy the fine datum ranges
%from Datum_Fix_Summary.xlsx into h_out3_datums_ranges.xlsx.
%
%%
%Import all of the selected datum intervals as column vectors using import wizard from h_out3_datums_ranges.xlsx,
%and find the mean of each datum interval with the following "for" loop.
%
%Run this before the for loop
%A few extra points from Jan. 22nd and 23rd of 2015 are called here to use
%for discharge calculations. They just make Matlab run more smoothly. 
h_out3(15480:15556) = lgr.SDXPress4(15480:15556);
%        
for i = 1:length(h_out3_datum_fix_start)
    h_out3_datums(i) = mean(h_out3(h_out3_datum_fix_start(i):h_out3_datum_fix_end(i)));   
end
%
%plot Datums
plot(h_out3(h_out3_datum_fix_start(i):h_out3_datum_fix_end(i)));
xlabel('# Points used for h-out3 Datums')
ylabel('Datum (ft)')
title('Plot of all datums used for drift fix of Cell 3 Stilling Well SDX')
%
%
%
h_out3(15480:15557) = NaN; %Remove these values, as they were added just
%for the for loop above to make matlab run more smoothly. 
%
%Flip matrix to be in easy direction for copy and paste into excel
h_out3_datums = h_out3_datums';
%
%Paste h_out3_datums generated from this "for" loop into
%the Excel file h_out3_apply.xlsx This excel file contains 3 columns: 2 with the applicable datum ranges and 1 with the datums. 

%%%--------------End Drift Correction Method for SDXPress4 (Cell 3)-------------

