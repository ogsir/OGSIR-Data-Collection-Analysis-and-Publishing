%Purpose: Calculation of Inflow/
%Created 1/26/15
%Modified 5/21/15
%Debugged 12/19/15

%Inputs:
    %h_sedbay_dc from the drift_correction_applied.m file
    
%Outputs:
    %Q_in_m3pers
    %Q_in_Lpers
    %V_in_Lincremental_with_rain

%%
%-------------Start Code for Inflow Rate-----------------
%
%
%Discharge calculations completed using metric system
%
%
h_sedbay_dc_m = h_sedbay_dc * 0.3048;   %Convert from ft to m
h_sedbay_dc_m = h_sedbay_dc_m + 0.002;   %Add 2 mm to h_in to account for manufactured vee shape

c_d = 0.6;                    %Coefficient of discharge
g = 9.807;                    %m/s^2
theta = pi/4;                 %angle of v-notch

%%
%---------Inflow Discharge Calculations

%Apply the standard v-notch weir equation to all values greater than 0
%to calculate flow over 1 sediment bay weir
%Note that negative values represent elevations in the sediment bay
%lower than the v-notch. 

for i = 1:length(h_sedbay_dc_m)
    if h_sedbay_dc_m(i) < 0;
        Q_in_m3pers(i) = 0;
    else
        Q_in_m3pers(i) = (8/15*c_d*sqrt(2*g)*tan(theta/2).*h_sedbay_dc_m(i).^(5/2)); %m^3/s
    end
end



Q_in_Lpers = Q_in_m3pers * 1000; %Convert from m^3/s to L/s
%
%Q_in = Q_in * 35.3147;                %Convert from m^3/s to ft^3/s
%Q_in = Q_in * 448.831169;             %Convert from ft^3/s to gal/min
%
%Multiply by 3 for the total discharge
%Q_in = 3*Q_in;
%
s = find(strcmpi('2014-10-21 14:45:00',lgr.Time)); %2014-10-21 14:45:00
e = datestr(T(end),31);
e = find(strcmpi(e,lgr.Time)); %2015-05-15 18:15:00
figure(2)
plot(T(s:e),Q_in_m3pers(s:e))
xlabel('Time');
ylabel('Inflow (GPM)');
datetick('x','mm/dd/yy')
title('Cell Inflow');
grid on


%---------End of code for inflow rate-----------
%%
%
%
%
%%
%------------Begin code for total volume of inflow----------

%Incremental and cumulative volume in (every 15 minutes) using the trapezoidal method of
%numerical integration

%Pre-fill the incremental and cumulative volume vectors
V_in_Lincremental(1:length(Q_in_Lpers)) = 0;
V_in_Lcumulative(1:length(Q_in_Lpers)) = 0;

V_in_Lincremental = V_in_Lincremental';
V_in_Lcumulative = V_in_Lcumulative';

%Initialize first value
V_in_Lincremental(1) = (Q_in_Lpers(1)+Q_in_Lpers(2))/2 * 60 * 15; %L in every 15 min
V_in_Lcumulative(1) = V_in_Lincremental(1); %L

%Make the V_in_L incremental and V_in_Lcumulative vectors
for i = 2:(length(Q_in_Lpers)-1)
    if isnan(Q_in_Lpers(i));
      V_in_Lincremental(i) = NaN;
    else
      V_in_Lincremental(i+1) = (Q_in_Lpers(i)+Q_in_Lpers(i+1))/2 * 60 * 15; %L in every 15 min
      V_in_Lcumulative(i) = V_in_Lcumulative(i-1) + V_in_Lincremental(i); %L
    end
end

%Fill in last values. 
V_in_Lincremental(end) = (Q_in_Lpers(end-1)+Q_in_Lpers(end))/2 * 60 * 15; %L
V_in_Lcumulative(end) = V_in_Lcumulative(end-1) + V_in_Lincremental(end); %L

%%
%Add precipitation that fell directly on the facility
V_in_Lincremental_with_rain = V_in_Lincremental + rain.P_L_direct; %L
V_in_Lcumulative_with_rain = V_in_Lcumulative + rain.P_L_cumulative; %L

%%
%Plot the pumped volume vs the direct precipitation volume. 
u = find(strcmpi('2014-10-21 14:30:00',lgr.Time));
u = T(u);
w = length(lgr.Time);
w = T(w);
plot(T,V_in_Lcumulative,T,rain.P_L_cumulative)
xlabel('Time','fontsize',14)
ylabel('Cumulative Volume (L)','fontsize',14)
legend('Pumped Volume', 'Direct Precipitation Volume')
title('Comparison of pumped volume vs. direct precipitation','fontsize',16)
xlim([u w])
datetick('x','keeplimits')
grid on


clear s t theta u w i g e c_d V_in_Lincremental V_in_Lcumulative
%--------------End code for total volume of inflow--------



%Abandonded code

% % % % % % 
% % % % % % %Inflow is calculated from the pressure transducer measurement using a weir equation.
% % % % % % 
% % % % % % %h_weir = 0.801; %ft, height from sensor to bottom of weir(m) measured 1/11/15 between 16:45 and 17:30 by bringing water level down to bottom of Vee, and letting it sit there for 4 readings. 
% % % % % % %The water surface tension height is 0.801ft, which came from a PDF during
% % % % % % %the month of January, which was considered the calibration period. 
% % % % % % 
% % % % % % %h_weir measured physically on 4/9/15
% % % % % % %h_weir = 0.836614; %ft
% 
% %Incremental inflow plot
% plot(T(1:end-1),V_in_L)
% xlabel('Time (days since 1/1/14)');
% ylabel('Incremental Inflow (gal/15 min)');
% title('Sediment Bay Incremental Inflow');
% datetick('x','mm-dd-yy')
% 
% %Cumulative inflow plot
% plot(T(1:end-1),V_in_Lcumulative)
% xlabel('Time');
% ylabel('Cumulative Inflow (gal)');
% title('Sediment Bay Cumulative Inflow');
% datetick('x','mm-dd-yy')
