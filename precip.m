%Update List: 5/11/15, 12/19/15
%Purpose: Make precipitation vectors, and correct any missing precipitation
%values with Hyslop data. 
%

%Inputs: import hyslop.csv as a table using the wizard. 
%Outputs: P, a complete precipitation vector using P values from Hyslop
%data to fill in missing values from Avery site. 

%%
%--Start Code for Rain Vector Fix--
P = lgr.Rain; %mm/(15 minutes)
%
%--------Missing Precipitation Data Fix-------
%Corrects all of the NaN values in the P vector using Hyslop Farm data
%http://www.usbr.gov/pn/agrimet/agrimetmap/crvoda.html 
    %Weather Data
    %Historical HOURLY/15 MINUTE Data Access 
    %CRVO  

 
%First make the hyslop date match the same format as the Matlab date format
tempdate = cellstr(datestr(hyslop.time,31));
hyslop.time = tempdate;
clear tempdate

%Now go fill in all the NaNs in P with the data from hyslop
j = 1;
for i = 1:length(lgr.Time)
    if isnan(lgr.Rain(i))
        Ptime = datestr(lgr.Time(i),31);
        Pfix = find(strcmpi(Ptime,hyslop.time));
        P(i) = hyslop.P_mm(Pfix); %mm/(15 minutes)
        j = j+1;
    end
end

clear Ptime Pfix j i 

%------------------End Missing Precipitation Data Fix--------
%%
%Find the amount of direction precipitation on the facility. 
%Convert precipitation from mm/15 minutes to in/hr
A_facility_m2 = 93.4 * 10.55 * 0.092903; %Area cal'd in ft^2, then converted to m^2
P_L_direct = P/1000 * A_facility_m2 * 1000; %L/15minutes, direct precipitation on facility

%Remove missing periods of time during which SDX data not available
e = find(strcmpi('2014-10-21 14:30:00',lgr.Time));
P_L_direct(1:e) = NaN;

s = find(strcmpi('2015-01-22 19:45:00',lgr.Time)); %start of fix
e = find(strcmpi('2015-02-26 10:15:00',lgr.Time)); %end of fix
P_L_direct(s:e) = NaN;

%%
%----------Start code for cumulative precipitation-----------
%This is cumulative precipitation that has fallen directly on the facility

% Initialize variables 
P_L_cumulative(1) = P_L_direct(1); % Cumulative precipitation, intialization of vector
P_L_cumulative(2:numel(P_L_direct)) = 0;
P_L_cumulative = P_L_cumulative';

% Make cumulative precipitation vector. 
for i = 2:(length(P_L_direct)-1)
    if ~isnan(P_L_direct(i));
        P_L_cumulative(i+1) = P_L_direct(i+1) + P_L_cumulative(i); %L
    end
end

%Fill in last value
P_L_cumulative(end) = P_L_cumulative(end-1)+P_L_direct(end);

%Plot

P_mmperhr = P*4; %note that the high rate observed in 15 minutes 
%did not necessarily last an hour.  This is done to be 
%consistent with the Corvalis IDF curves 

bar(T,P_mmperhr)
title('Measured Precipitation and Return Events','FontSize',16)
xlabel('Time','FontSize',14)
ylabel('Precipitation (mm/hr)','FontSize',14)
s = datenum('2014-08-14 14:00:00');
e = datenum('2015-05-15 18:15:00');
xlim([s e]);
datetick('x','mm/dd/yy','keeplimits')
grid on


%------------------end code for cumulative precipitation------------


%Plot of precipitation with return events
%Reference: Corvallis Rainfall Intensity - Duration - Recurrence Intervals
%Units are in/hr
return_year = [2 5 10 25 50 100];
return_event = [1.02 1.31 1.5 1.73 1.96 2.2];

for i = 1:length(return_event);
    hold on
    x = return_event(i)*25.4; %convert from in to mm;
    refline(0,x)
end
leg = legend('Precipitation','100 Year Return Event',...
    '50 Year Return Event','25 Year Return Event',...
    '10 Year Return Event','5 Year Return Event',...
    '2 Year Return Event')

datetick('x','mm/dd/yy')
xlabel('Time')
ylabel('Precipitation(in/hr)')
title('Rain')

%Clean up all the variables and put them in 1 table
rain = table(P,P_L_direct,P_L_cumulative,P_mmperhr);


clear return_event return_year s e x leg i hyslop P P_L_direct P_L_cumulative P_mmperhr

%Abandonded code

% 
% %
%         %At 9/22/2014 3:00 = 0 inches Precipitation
%         tfix = find(strcmpi('2014-09-22 03:00:00',lgr.Time));
%         P(tfix) = 0; %in/15min
%         %At 10/07/2014 18:00 = 0 inches Precipitation
%         P(1386) = 0; %in/15min
%         %At 10/20/2014 17:45 = 0 inches Precipitation
%         P(2516) = 0; %in/15min
%         %At 11/3/2014  16:15 = 0 inches Precipitation
%         P(3818) = 0; %in/15min
%         %At 11/13/14 4:45 = 0.01 inches Precipitation
%         P(4673) = 0.01; %in/15min
%         %At 11/14/14 6:30 =  0 inches Precipitation
%         P(4776)= 0; %in/15min
%         % At 11/19/14 9:15 = 0 inches precipitation
%         P(5128)= 0; %in/15min
%         % At 3/10/15 0:30 = 0 inches precipitation
%         P(15740)= 0; %in/15min
%         % At 3/20/15 22:00 = 0.04 inches precipitation
%         P(16779)= 0.04; %in/15min

% 
% %Correct Precipitation data using average of values around it. 
% for i = 2:length(P);
%     if isnan(P(i))
%         P(i) = (P(i-1)+P(i+1));
%     end
% end

