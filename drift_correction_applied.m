%Grant Livingston
%Purpose: Apply the drift correction to the sediment bay and Cell 3 head
%data.
%Created 4/21/15
%Modified 4/21/15
%Debugged 12/19/15, 1/29/16


%INPUTS: 
    %h_sedbay - the lgr data from the sediment bay
    %h_out3 - the lgr data from Cell 3 stilling well
    %Import Wizard --> go to this folder...Error Analyses/Datum Fix/
    %Import the following files as column vectors. 
    
        %h_sedbay_datums_ranges.xlsx
        %h_sedbay_apply.xlsx
        
        %h_out3_datums_ranges.xlsx
        %h_out3_apply.xlsx
        

%OUTPUTS:
    %h_sedbay_dc_ft - drift corrected sediment bay data (feet)
    %sedbay - a table of sediment bay drift correction values. The tables 
    %has the following columns: Applicable range start, datum range start,
    %datum range end, applicable range end, datums
    %
    %h_out3_dc_ft - drift corrected Cell 3 data (feet)
    %out3 - a table of Cell 3 drift correction values. The tables 
    %has the following columns: Applicable range start, datum range start,
    %datum range end, applicable range end, datums


%%%--------Start Drift Correction Applied for SDXPress1 (Sediment Bay)-------------
% 
%
%visualize a table of the corrections with this:
h_sedbay_summary = table(h_sedbay_range_start,h_sedbay_datum_fix_start,h_sedbay_datum_fix_end,h_sedbay_range_end,h_sedbay_datums);
%
%This small amount of code is acutally a pretty bid deal !
%Apply the datum fix to the appropriate range. 
%dc stands for drift corrected
for i = 1:length(h_sedbay_summary.h_sedbay_datums)
    h_sedbay_dc_ft(h_sedbay_summary.h_sedbay_range_start(i):h_sedbay_summary.h_sedbay_range_end(i)) = h_sedbay(h_sedbay_summary.h_sedbay_range_start(i):h_sedbay_summary.h_sedbay_range_end(i)) - h_sedbay_summary.h_sedbay_datums(i);
end

%Flip matrix
h_sedbay_dc_ft = h_sedbay_dc_ft';

%Visualize Corrections
for i = 1:length(h_sedbay_summary.h_sedbay_datums)
    %prefix
    subplot(3,1,1)
    plot(T(h_sedbay_summary.h_sedbay_range_start(i):h_sedbay_summary.h_sedbay_range_end(i)),...
        h_sedbay(h_sedbay_summary.h_sedbay_range_start(i):h_sedbay_summary.h_sedbay_range_end(i)));
    
    hold on
    subplot(3,1,1)
    plot(T(h_sedbay_summary.h_sedbay_datum_fix_start(i):h_sedbay_summary.h_sedbay_datum_fix_end(i)),...
        h_sedbay(h_sedbay_summary.h_sedbay_datum_fix_start(i):h_sedbay_summary.h_sedbay_datum_fix_end(i)),'c');
    hold off
    
    title('Pre Drift Correction')
    ylabel('ft')
    grid on
    grid minor
    datetick('x',21,'keeplimits')
    
    
    %postfix
    subplot(3,1,2)
    plot(T(h_sedbay_summary.h_sedbay_range_start(i):h_sedbay_summary.h_sedbay_range_end(i)),...
        h_sedbay_dc_ft(h_sedbay_summary.h_sedbay_range_start(i):h_sedbay_summary.h_sedbay_range_end(i)));
    title('Post Drift Correction')
    ylabel('ft')
    grid on
    grid minor
    datetick('x',21,'keeplimits')  
    
    subplot(3,1,3)
    bar(T(h_sedbay_summary.h_sedbay_range_start(i):h_sedbay_summary.h_sedbay_range_end(i)),...
        rain.P(h_sedbay_summary.h_sedbay_range_start(i):h_sedbay_summary.h_sedbay_range_end(i)));
    title('Precipitation')
    ylabel('mm/15 minutes')
    grid on
    grid minor
    
    datetick('x',21,'keeplimits')
    
    pause
end 

clear h_sedbay_range_start h_sedbay_datum_fix_start h_sedbay_datum_fix_end h_sedbay_range_end h_sedbay_datums l i e s 
    
%%%--------------End Drift Correction Applied for SDXPress1 (Sed Bay)-------------
%
%%

%%%--------Start Drift Correction Applied for SDXPress4 (Cell 3)-------------
%
%visualize a table of the corrections with this:
h_out3_summary = table(h_out3_range_start,h_out3_datum_fix_start,h_out3_datum_fix_end,h_out3_range_end,h_out3_datums);
%
%This small amount of code for the following for loop is acutally a pretty bid deal !
%
%Apply the datum fix to the appropriate range. 
%dc stands for drift corrected
for i = 1:length(h_out3_summary.h_out3_datums)
    h_out3_dc_ft(h_out3_summary.h_out3_range_start(i):h_out3_summary.h_out3_range_end(i)) = h_out3(h_out3_summary.h_out3_range_start(i):h_out3_summary.h_out3_range_end(i)) - h_out3_summary.h_out3_datums(i);
end

%Flip matrix
h_out3_dc_ft = h_out3_dc_ft';


%Visualize Corrections
for i = 1:length(h_out3_summary.h_out3_datums)
    %prefix
    subplot(3,1,1)
    plot(T(h_out3_summary.h_out3_range_start(i):h_out3_summary.h_out3_range_end(i))...
        ,h_out3(h_out3_summary.h_out3_range_start(i):h_out3_summary.h_out3_range_end(i)));
    
    hold on
    subplot(3,1,1)
    plot(T(h_out3_summary.h_out3_datum_fix_start(i):h_out3_summary.h_out3_datum_fix_end(i)),...
        h_out3(h_out3_summary.h_out3_datum_fix_start(i):h_out3_summary.h_out3_datum_fix_end(i)),'c');
    hold off
    
    title('Pre Drift Correction')
    ylabel('ft')
    grid on
    grid minor
    datetick('x',21,'keeplimits')
    
    %postfix
    subplot(3,1,2)
    plot(T(h_out3_summary.h_out3_range_start(i):h_out3_summary.h_out3_range_end(i)),...
        h_out3_dc_ft(h_out3_summary.h_out3_range_start(i):h_out3_summary.h_out3_range_end(i)));
    title('Post Drift Correction')
    ylabel('ft')
    grid on
    grid minor
    datetick('x',21,'keeplimits')  
    
    subplot(3,1,3)
    plot(T(h_out3_summary.h_out3_range_start(i):h_out3_summary.h_out3_range_end(i)),...
        h_sedbay_dc_ft(h_out3_summary.h_out3_range_start(i):h_out3_summary.h_out3_range_end(i)));
    title('Sediment Bay')
    ylabel('mm/15 minutes')
    grid on
    grid minor
    
    datetick('x',21,'keeplimits')
    
    pause
end 

clear h_out3_range_start h_out3_datum_fix_start h_out3_datum_fix_end h_out3_range_end h_out3_datums l i e s 
    
%%%--------------End Drift Correction Applied for SDXPress4 (Cell3)-------------



