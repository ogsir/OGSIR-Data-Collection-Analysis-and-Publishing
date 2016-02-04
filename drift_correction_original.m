%Grant Livingston
%Purpose: Find datums for drift correction and apply them. 
%Created 4/21/15
%Modified 4/21/15
%Debugged 12/19/15

%%%--------Start Drift Correction for SDXPress1 (Sediment Bay)-------------
% 
%INPUTS: 
    %h_sedbay variable from 1st part of inflow_calc.m
%Import Datum Fix folder Excel files. 


%OUTPUTS:
    %h_sedbay_dc - drift corrected sediment bay head. 

%Be sure to see Datum Fix folder under the error analysis folder.
%You will use the all the Excel files in this 
%folder except Datum_Fix_summary.xlsx (unless you are 
%searching for new datums) along with this code to apply 
%the datum fix. However, the method could be improved. 
%It is currently slow, and it requires lots of manual graphical
%analysis (days of time to complete...). 
%
%
%
%% 
%--------Start: Bias Correction for SDXPress1 (SedBay)-------

%Collect data from lgr
h_sedbay = lgr.SDXPress1;

%%%--Sensor Fails - Caused nonsensicle data
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
%%%--Other Erros - Caused NaNs
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
%%
%



%Use this plot to find datum intervals. Manually enter them
%into Excel in Datum_Fix_Summary.xlsx

%HINT: Use pan and zoom tools. 

%First time data is good is 10/21/14 at 14:45
s = find(strcmpi('2014-10-21 14:45:00',lgr.Time)) 
l = length(lgr.Time); 

%672 is number of timesteps in a week, 960 for 10 days. 700 is a 
%good number of timesteps to view in 1 window while searching
%for datums. 
for i = s:700:l 
    s = i; e = i+700;
figure(1)
[AX,H1,H2] = plotyy(t,h_sedbay,t,rain.P,'plot','bar')

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

datetick('x',1,'keeplimits')

pause
end

clear H1 H2 AX i l s e

%
%At this stage, you should have recorded all of the datums and
%ranges in the applicable excel files. 
%
%%
%Import all of the selected datum intervals from h_sedbay_datums.xlsx,
%and find the mean of each datum interval with this "for" loop.
%Paste h_sedbay_datams generated from this "for" loop into
%the Excel file h_sedbay_range.xlsx 

for i = 1:length(h_sedbay_datum_fix_start)
    h_sedbay_datums(i) = mean(h_sedbay(h_sedbay_datum_fix_start(i):h_sedbay_datum_fix_end(i)));
    hold on
    plot(h_sedbay(h_sedbay_datum_fix_start(i):h_sedbay_datum_fix_end(i)));
end

%Flip matrix to be in easy direction for copy and paste into excel
h_sedbay_datums = h_sedbay_datums';

%plot Datums
xlabel('# Points used for h-in Datums')
ylabel('Datum (ft)')
title('Plot of all datums used for drift fix of Sediment Bay SDX')

%Apply the datum fix to the appropriate range. 
%dc stands for drift corrected
for i = 1:length(h_sedbay_datums)
    h_sedbay_dc(h_sedbay_range_start(i):h_sedbay_range_end(i)) = h_sedbay(h_sedbay_range_start(i):h_sedbay_range_end(i)) - h_sedbay_datums(i);
end

%Flip matrix
h_sedbay_dc = h_sedbay_dc';

%visualize a table of the corrections with this:
sedbay = table(h_sedbay_range_start,h_sedbay_datum_fix_start,h_sedbay_datum_fix_end,h_sedbay_range_end,h_sedbay_datums);

%Visualize Corrections
for i = 1:length(h_sedbay_datums)
    %prefix
    subplot(3,1,1)
    plot(T(h_sedbay_range_start(i):h_sedbay_range_end(i)),h_sedbay(h_sedbay_range_start(i):h_sedbay_range_end(i)));
    title('Pre Drift Correction')
    ylabel('ft')
    grid on
    grid minor
    datetick('x',21,'keeplimits')
    
    %postfix
    subplot(3,1,2)
    plot(T(h_sedbay_range_start(i):h_sedbay_range_end(i)),h_sedbay_dc(h_sedbay_range_start(i):h_sedbay_range_end(i)));
    title('Post Drift Correction')
    ylabel('ft')
    grid on
    grid minor
    datetick('x',21,'keeplimits')  
    
    subplot(3,1,3)
    bar(T(h_sedbay_range_start(i):h_sedbay_range_end(i)),rain.P(h_sedbay_range_start(i):h_sedbay_range_end(i)));
    title('Precipitation')
    ylabel('mm/15 minutes')
    grid on
    grid minor
    
    datetick('x',21,'keeplimits')
    
    pause
end 

clear h_sedbay_range_start h_sedbay_datum_fix_start h_sedbay_datum_fix_end h_sedbay_range_end h_sedbay_datums
    
%%%--------------End Bias Correction for SDXPress1 (Sed Bay)-------------

%%
%%----------------Start Bias Correction for SDXPress4 (Cell 3)---------------
%This code is used to look for datums 
%
%
s = find(strcmpi('2014-10-21 14:45:00',lgr.Time)) %First time data is good is 10/21/14 at 14:45
l = length(lgr.Time); 

for i = s:700:l
    s = i; e = i+700;
figure(1)
[AX,H1,H2] = plotyy(t,h_out3,t,h_in,'plot','plot')

set(get(AX(1),'Ylabel'),'String','Cell 3 Stilling Well Measurement (ft)')
set(get(AX(2),'Ylabel'),'String','Sediment Bay Water Level (ft))')
set(get(AX(1),'Xlabel'),'String','Time')

title('SDXPress4 Baseline');
legend([H1,H2],'h_out3','h_in')

set(AX(1),'YLim',[1.52,1.72],'xlim',[s e])
set(AX(1),'YTick', [1.52:0.01:1.72]);

set(AX(2),'YLim',[0.75,2],'xlim',[s e])
set(AX(2),'YTick', [0.75:0.1:2]);

set(H1,'Marker','o','MarkerSize',3)

grid minor
grid on
%datetick('x','keeplimits')

pause
end
%%
%------Start Datum Vector for Cell 3 Outflow----------
%This bit of code will first find the mean of all of the datum intervals. Then
%it will apply the datum to the applicable interval. 

%Needed:
    %h_out3_datums.xlsx, 2 column vector with the start and end of the datum
    %intervals
    %h_out3_range, 3 columns. 2 with the applicable datum ranges and 1 with the datums. 
    %A few extra points from Jan. 2015 will be used for discharge calculations. 
        h_out3(15480:15557) = lgr.SDXPress4(15480:15557);

%Import all of the selected datum ranges from Excel file, and find their
%mean with this for loop.
            %fix the NaNs with an average
            %h_out3(9998) = (h_out3(9997)+h_out3(9999))/2;
            %h_out3(10641) = (h_out3(10640)+h_out3(10643))/2;
            %h_out3(13944) = (h_out3(13943)+h_out3(13945))/2;
            %h_out3(24957) = (h_out3(24956)+h_out3(24958))/2;
            h_out3(24955) = (h_out3(24954)+h_out3(24956))/2; %outlier, make it an average
for i = 1:length(datstarth_out3)
    h_out3_datums(i) = mean(h_out3(datstarth_out3(i):datendh_out3(i)));
    hold on
    plot(h_out3(datstarth_out3(i):datendh_out3(i)));
end
h_out3(15480:15557) = NaN; %Remove these values, as they were added just
%for the for loop aboce

%Flip matrix to be in easy direction for copy and paste into excel
h_out3_datums = h_out3_datums';

%plot Datums
xlabel('# Points used for h-out3 Datums')
ylabel('Datum (ft)')
title('Plot of all datums used for drift fix of Cell 3 Stilling Well SDX')

%Apply the datum fix. 

for i = 1:length(h_out3_datums)
    h_out3(h_out3_rs(i):h_out3_re(i)) = h_out3(h_out3_rs(i):h_out3_re(i)) - h_out3_datums(i);
end

%%----------------End SDXPress4 (Cell 3) ---------

