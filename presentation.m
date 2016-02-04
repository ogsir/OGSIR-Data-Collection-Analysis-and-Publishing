%Plots for presentation






%Showing the base corrections
%SB Raw
x = SDXPress1 - 0.836614;
s = 6532;
e = 15498;
plot(T(s:e),x(s:e))
ylim([-.1 0.3])
%refline(0,0.836614)
xlabel('Time')
ylabel('Depth (ft)')
title('Sediment Bay Water Depth Physically Measured Datum Adjusted Data')
datetick('x','mm/dd/yy','keeplimits')
grid on

%SB Corrected
s = 6532;
e = 15498;
plot(T(s:e),h_in(s:e))
ylim([-.1 0.3])
%refline(0,0.836614)
xlabel('Time')
ylabel('Depth (ft)')
title('Sediment Bay Water Depth Calibration Corrected')
datetick('x','mm/dd/yy','keeplimits')
grid on


figure(1)
%Cell3 Out Raw
x = SDXPress4 - 1.58793;
s = 6532;
e = 15498;
plot(T(s:e),x(s:e))
ylim([-.1 0.3])
xlabel('Time')
ylabel('Depth (ft)')
title('Cell 3 Outflow Water Depth Physically Measured Datum Adjusted Data')
datetick('x','mm/dd/yy','keeplimits')
grid on

figure(2)
%Cell3 Out Corrected
s = 6532;
e = 15498;
plot(T(s:e),h_out3(s:e))
ylim([-.1 0.3])
%refline(0,0.836614)
xlabel('Time')
ylabel('Depth (ft)')
title('Cell 3 Outflow Water Depth Calibration Corrected')
datetick('x','mm/dd/yy','keeplimits')
grid on










%Plotting hyetograph and hydrograph in same plot.


%T is timestamp in datenumber format
%Rain is rainfall time-series in mm
%T is timestamp for discharge in datenumber format
%Q_in is discharge in ft^3/s

%--- start of code for plotting hyetographs and hydrographs---
% s = 6532;
% e = 15498;
s = 6800;
e = 7200;

figure(1);
[AX,H1,H2] = plotyy(T(s:e),P(s:e),T(s:e),Q_in(s:e),'bar','plot');

% Set bar graph properties
set(get(AX(1),'Ylabel'),'String','Precipitation (inches/hour)')
set(AX(1),'YDir', 'reverse') 
set(AX(2),'XAxisLocation','top')
set(get(AX(1),'Xlabel'),'String','Time')
set(AX(1),'YLim',[0,1])
set(AX(1),'YTick', [0:0.125:1]);

% Set line graph properties
set(get(AX(2),'Ylabel'),'String','Discharge (Gallons/Minute)')
%set(AX(2),'Ylim',[0,15])
%set(AX(2),'YTick', [0:1:15]);

% Print Month and Year as Tick Label
xlabel('Time')
datetick('x','mm/dd/yy','keeplimits','keepticks')

% Print graph title
title('Hyetograph, Inflow Hydrograph, and Cell 3 Outflow Hydrographs');

% Plot other graphs
set(AX,'NextPlot','add')
%p3 = plot(AX(2),T(s:e),Q_out2(s:e))
p4 = plot(AX(2),T(s:e),Q_out3(s:e))
%p5 = plot(AX(2),T(239),Q_in(239),'o') 
%p6 = plot(AX(2),T(240),Q_out3(240),'o')
%p7 = plot(AX(2),T(543),Q_in(543),'o') 
%p8 = plot(AX(2),T(542),Q_out3(542),'o')

%p5 = refline(0,1.2)
%set(p5,'color','k')
legend([H1,H2,p4],'Precipitation','Q-in','Q-out3')
grid on

%--- end of code for plotting hyetographs and hydrographs---
%
%
%
%
%
%---------- start of code for plotting treatment efficiency------------

 
%Cumulative inflow plot

s = 6532;
e = 15498;

%plot(T,V_Runoff,T(1:end-1),V_in_cumulative_total,'--')
x = V_in_cumulative*3;
plot(T(s:e),x(s:e),'--')
xlabel('Time');
ylabel('gal');
title('Inflow Volume');
datetick('x','mm-dd-yy')
grid on

%V_treated using electrical data
T_treated = VarName1;
T_treated = datenum(T_treated);
V_treated = VarName2;

hold on
plot(T_treated,V_treated,'-o')
legend('Runoff Volume','Pumped Volume (weir data)','Pumped Volume (electricity data)')

max(V_in_cumulative_total)/max(V_Runoff)*100
max(V_treated)/max(V_Runoff)*100

%-- end of code for plotting treatment efficiency--
