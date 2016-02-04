%Grant Livingston
%Created 5/23/15
%Modified 5/24/15
%Purpose: Calculate volumes from flowrates, then plot the cumulative volumes for a volume balance
%Contains similar code as in inflow_calcs.m and outflow_calcs.m 



%%
%------------Begin code for total volume of inflow----------

%Incremental and cumulative volume in (every 15 minutes) using the trapezoidal method of
%numerical integration

%Pre-fill the incremental and cumulative volume vectors
V_in_L_cal(1:length(Q_in_Lpers_cal)) = 0;
V_in_Lcumulative_cal(1:length(Q_in_Lpers_cal)) = 0;

%Initialize first value
V_in_L_cal(1) = (Q_in_Lpers_cal(1)+Q_in_Lpers_cal(2))/2 * 60 * 15; %L in every 15 min
V_in_Lcumulative_cal(1) = V_in_L_cal(1); %L

%Make the V_in_L incremental and V_in_Lcumulative vectors
for i = 2:(length(Q_in_Lpers_cal)-1)
    if isnan(Q_in_Lpers_cal(i));
      V_in_L_cal(i) = NaN;
    else
      V_in_L_cal(i+1) = (Q_in_Lpers_cal(i)+Q_in_Lpers_cal(i+1))/2 * 60 * 15; %L in every 15 min
      V_in_Lcumulative_cal(i) = V_in_Lcumulative_cal(i-1) + V_in_L_cal(i); %L
    end
end

%Fill in last values. 
V_in_L_cal(end) = (Q_in_Lpers_cal(end-1)+Q_in_Lpers_cal(end))/2 * 60 * 15; %L
V_in_Lcumulative_cal(end) = V_in_Lcumulative_cal(end-1) + V_in_L_cal(end); %L

%Flip flop
%V_in_L_cal = V_in_L_cal';
%V_in_Lcumulative_cal = V_in_Lcumulative_cal';
%%

%Add precipitation
V_in_all_cal = V_in_L_cal + P_L; %L
V_in_allcumulative_cal = V_in_Lcumulative_cal + P_cumulative_L; %L
%
%
%--------------End code for total volume of inflow--------
%
%
%%
%------------Begin code for Cell 3 volume outflow-------

%Pre-fill the incremental and cumulative volume vectors
V_out3_L_cal(1:length(Q_out3_Lpers_cal)) = 0;
V_out3_Lcumulative_cal(1:length(Q_out3_Lpers_cal)) = 0;

%Initialize first value
V_out3_L_cal(1) = (Q_out3_Lpers_cal(1)+Q_out3_Lpers_cal(2))/2 * 60 * 15; %L out every 15 minutes
V_out3_Lcumulative_cal(1) = V_out3_L_cal(1); %L

%Make the V_out3_L incremental and V_out3_Lcumulative vectors
for i = 2:(length(Q_out3_Lpers_cal)-1)
    if isnan(Q_out3_Lpers_cal(i));
        V_out3_L_cal(i) = NaN;
    else
        V_out3_L_cal(i+1) = (Q_out3_Lpers_cal(i)+Q_out3_Lpers_cal(i+1))/2 * 60 * 15; %L out every 15 minutes
        V_out3_Lcumulative_cal(i) = V_out3_Lcumulative_cal(i-1) + V_out3_L_cal(i); %L
    end
end

%Fill in the last values
V_out3_L_cal(end) = (Q_out3_Lpers_cal(end-1)+Q_out3_Lpers_cal(end))/2 * 60 * 15; %L
V_out3_Lcumulative_cal(end) = V_out3_Lcumulative_cal(end-1) + V_out3_L_cal(end); %L
%%

%Flip rows and columns
%V_out3_L_cal = V_out3_L_cal';
%V_out3_Lcumulative_cal = V_out3_Lcumulative_cal';

%Add Evapotranspiration

V_out3_all_cal = V_out3_L_cal + ET_Cell3; %L
V_out3_allcumulative_cal = V_out3_Lcumulative_cal + ET_cumulative_L; %L


%------------End code for Cell 3 volume outflow-------


%%
%------------------------Cell 3 Volume balance---------------
%Cell 3 with Calibrated Data can easily be plotted by changing
%the parameters of the plot function and title function.

figure(1)
s = find(strcmpi('2014-10-21 14:45:00',lgr.Time)); %int
e = length(lgr.Time); %int

plot(T(s:e),V_in_Lcumulative(s:e),'-k',T(s:e),...
    V_out3_allcumulative(s:e),'--k')
xlabel('Time','FontSize',14)
ylabel('Cumulate Volume (L)','FontSize',14)
title('Drift Corrected Total Cumulative Inflow and Outflow Volumes','FontSize',16)
leg = legend('V-in','V-Out3')
set(leg,'FontSize',14)
xlim([T(s) T(e)])
datetick('x','mm/dd/yy','keeplimits')
grid on
%%
%
%clear V_in_L_cal V_in_Lcumulative_cal V_in_all_cal V_in_allcumulative_cal...
    %V_out3_L_cal V_out3_Lcumulative_cal V_out3_all_cal V_out3_allcumulative_cal
%
%

%Abandonded code
% volbal = V_in_cumulative - V_out3_cumulative;
% voldiff = V_in - V_out3;
% 
% [AX,H1,H2] = plotyy(T(s:e),volbal(s:e),T(s:e),Q_in(s:e))
% datetick('x','keeplimits')
% set(AX,'NextPlot','add')
% p3 = plot(AX(2),T(s:e),Q_out3(s:e),'k');
% legend('diff','V_in','V_out')
% 
% plotyy(t(s:e),voldiff(s:e),t(s:e),P(s:e))
% 
% plot(t(1:end-1),V_out3)
% xlabel('Time (days since 1/1/14)');
% ylabel('Outflow (L)');
% title('Cell 3 Incremental Outflow');
% %%