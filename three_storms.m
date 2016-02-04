%Grant Livingston
%Created 5/24/15        
%Modified 5/24/15  
%Plot 3 storms before and after calibration

%-------------Start Code Pre-Storm-Calibration---------
%%
figure(1)
%Storm 1
subplot(3,1,1)
s = find(strcmpi('2014-10-24 00:00:00',lgr.Time));
e = find(strcmpi('2014-10-28 00:00:00',lgr.Time));

plot(T,Q_in_Lpers,'-k',T,Q_out3_Lpers,'--k','MarkerSize',1);
title('Drift Corrected Fall, Winter, and Spring Storms. 96 Hours Each','FontSize',16)
ylabel('Flowrate (L/s)','FontSize',14)
leg = legend('Inflow, Sed. Bay Weir','Outflow, Underdrain Weir');
set(leg,'FontSize',14,'Location','NorthEast')
xlim([T(s) T(e)]);
ylim([0 0.85]);
datetick('x',2,'keeplimits')
grid on
%
%
%Storm 2
subplot(3,1,2)
s = find(strcmpi('2014-12-27 00:00:00',lgr.Time));
e = find(strcmpi('2014-12-31 00:00:00',lgr.Time));

plot(T,Q_in_Lpers,'-k',T,Q_out3_Lpers,'--k','MarkerSize',1);
ylabel('Flowrate (L/s)','FontSize',14)
xlim([T(s) T(e)]);
ylim([0 0.85]);
datetick('x',2,'keeplimits')
grid on
%
%Storm 3
subplot(3,1,3)
s = find(strcmpi('2015-03-30 12:00:00',lgr.Time));
e = find(strcmpi('2015-04-03 12:00:00',lgr.Time));

plot(T,Q_in_Lpers,'-k',T,Q_out3_Lpers,'--k','MarkerSize',1);
ylabel('Flowrate (L/s)','FontSize',14)
xlabel('Time','FontSize',14)
xlim([T(s) T(e)]);
ylim([0 0.85]);
datetick('x',2,'keeplimits')
grid on
%
%
%-------------End Code Pre-Storm-Calibration---------
%
%
%-------------Start Code Post-Storm-Calibration---------
%%
figure(2)
%Storm 1
subplot(3,1,1)
s = find(strcmpi('2014-10-24 00:00:00',lgr.Time));
e = find(strcmpi('2014-10-28 00:00:00',lgr.Time));

plot(T,Q_in_Lpers_cal,'-k',T,Q_out3_Lpers_cal,'--k','MarkerSize',1);
title('Drift Corrected & Calibrated Fall, Winter, and Spring Storms. 96 Hours Each','FontSize',16)
ylabel('Flowrate (L/s)','FontSize',14)
leg = legend('Inflow, Sed. Bay Weir','Outflow, Underdrain Weir');
set(leg,'FontSize',14,'Location','NorthEast')
xlim([T(s) T(e)]);
ylim([0 0.85]);
datetick('x',2,'keeplimits')
grid on
%
%
%Storm 2
subplot(3,1,2)
s = find(strcmpi('2014-12-27 00:00:00',lgr.Time));
e = find(strcmpi('2014-12-31 00:00:00',lgr.Time));

plot(T,Q_in_Lpers_cal,'-k',T,Q_out3_Lpers_cal,'--k','MarkerSize',1);
ylabel('Flowrate (L/s)','FontSize',14)
xlim([T(s) T(e)]);
ylim([0 0.85]);
datetick('x',2,'keeplimits')
grid on
%
%Storm 3
subplot(3,1,3)
s = find(strcmpi('2015-03-30 12:00:00',lgr.Time));
e = find(strcmpi('2015-04-03 12:00:00',lgr.Time));

plot(T,Q_in_Lpers_cal,'-k',T,Q_out3_Lpers_cal,'--k','MarkerSize',1);
ylabel('Flowrate (L/s)','FontSize',14)
xlabel('Time','FontSize',14)
xlim([T(s) T(e)]);
ylim([0 0.85]);
datetick('x',2,'keeplimits')
grid on
%
%
%-------------End Code Post-Storm-Calibration---------
%
%

