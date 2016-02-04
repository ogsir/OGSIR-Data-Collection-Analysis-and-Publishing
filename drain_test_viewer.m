%%Grant Livingston
%Purpose: Compare Drain tests at diffferent points in time
%Created 3/31/15
%Modified 3/31/15

%SDXPress4 and 5 (Cell 3 and Cell 2)
h_out3 = SDXPress4; %Cell 3
h_out2 = SDXPress5; %Cell 2

%Cell 2 drain Tests
s = 6532;  %2014/10/21 14:45:00
e = 21502; %2015/03/26 13:15:00

figure(1)
plot(t(s:e),h_out2(s:e),'-o')
xlabel('Time')
ylabel('Water Level (ft)')
title('Cell 2 Drain Test')
axis([s e 1.35 2])

%Time for Draintest 1
%Cell 2 7832:8032, Peak at 7862. (2014-11-04 03:45:00 to 2014-11-06 05:45:00, peak at 2014-11-04 11:15:00)
%Cell 2 
%Cell 3 8310:8510. Peak at 8340. (2014-11-09 03:15:00 to 2014-11-11 05:15:00, peak at 2014-11-09 10:45:00)

%Time for Draintest 2
%Cell 2 21220:21420, Peak at  . (3/23/2015 14:45 to 3/25/2015 16:45, peak at )
%Cell 3 21230:21430, Peak at 21260 (3/23/2015 17:15 to 3/25/2015 19:15, peak at 3/24/2015 0:45)


%Cell 2
%Have all cells start at same place

figure(1)
dt = 1:0.25:51
plot(dt(1:201),h_out2(7832:8032),'-o')
xlabel('Time (Hours)')
ylabel('Water Level (ft)')
title('Cell 2 Drain Tests #1a #1b and #2')
axis([1 51 1.4 2.1])
hold on
plot(dt(1:201),h_out2(21220:21420),'-*')
legend('Test #1a Nov. 4-5, 2014', 'Test #2 Mar. 23-24, 2015')
grid on
hold off

%Cell 3
figure(2)
dt = 1:0.25:51
plot(dt(1:161),h_out3_mm(8310:8470),'-k')
xlabel('Time (Hours)','FontSize',14)
ylabel('Water Level Behind Weir (mm)','FontSize',14)
title('Cell 3 Drain Tests #1 and #2','FontSize',16)
axis([0 42 -20 130])
hold on
plot(dt(1:161),h_out3_mm(21230:21390),'--k')
leg = legend('Test #1 Nov. 9-10, 2014', 'Test #2 Mar. 23-24, 2015')
set(leg,'FontSize',14,'Location','NorthEast')
grid on
hold off
