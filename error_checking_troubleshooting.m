%Grant Livingston
%Purpose: Trouble shooting and error checking all sensors
%Created 2/20/15
%Modified 4/13/15


%Potential problem sensors: SDXPress3, SDXPress5, pF8, pF4, pF7,
%pyranometer

%----------SDXPress3 and SDXPress5-------------------

[AX,H1,H2] = plotyy(T,SDXPress3,T,Rain)
set(get(AX(1),'Ylabel'),'String','SDX Measurement (ft)')
set(get(AX(2),'Ylabel'),'String','Precipitation (mm/15 min)')
set(get(AX(1),'Xlabel'),'String','Time')
title('SDXPress3 - A piezometer that measures the "water table" in the bioswale');
legend([H1,H2],'SDXPress3 Sensor','Precipitation')
datetick('x')
grid minor
refline(0,0)

plot(T,SDXPress4,T,SDXPress5)
ylabel('SDX Measurement (ft)')
xlabel('Time')
title('SDXPress5 Drift');
datetick('x')
grid on
legend('SDXPress4 Sensor','SDXPress5 Sensor')


%---------pF8, pF4, pF7-------------------------------

figure(3)
[AX,H1,H2] = plotyy(T,pF4,T,Temp4);
datetick('x')
set(get(AX(1),'Ylabel'),'String','pF')
set(get(AX(2),'Ylabel'),'String','Temperature (deg. C)')
set(get(AX(1),'Xlabel'),'String','Time')
set(AX,'NextPlot','add')
p3 = plot(AX(1),T,pF6)
set(p3,'color','k')

legend([H1,p3,H2],'TensioMark Tensiometer that is not working','TensioMark Tensiometer that is working',...
    'Temperature from broken sensor')





%-----------dealing with SDXPress1 and SDXPress2 after the ports that the sensors are in were switched------------

%Indexes need to be updated t = 7000 = 2014-12-08 23:00:00, t = 2442 = 2014/10/18 20:45:00
plot(T1(7000:end),SDXPress3(7000:end),'k',T(1:2442),SDXPress1(1:2442),'k',T(2443:end),SDXPress2(2443:end))
refline(0,0.8)
xlabel('Time')
ylabel('Water Depth(ft)')
datetick('x','mm/dd/yy')
title('Issue with the SDX Pressure Transducer in the Sediment Bay')


%-----New SDXPress1 Sensor with 2.5ft range.---------

[AX,H1,H2] = plotyy(T,SDXPress1,T,BarPress)
set(get(AX(1),'Ylabel'),'String','SDX Measurement (ft)')
set(get(AX(2),'Ylabel'),'String','Barometric Pressure')
set(get(AX(1),'Xlabel'),'String','Time')
title('Comparing Barometric Pressure with Baseline');
legend([H1,H2],'SDXPress1','Barometric Pressure')
datetick('x')
grid minor
refline(0,0)

x = BarPress * 0.04460334762;
y = SDXPress1 - x;

plot(T,y)
grid on
%--------NetRadiation-------------

plot(T(8300:9000),NetRad_Wm2(8300:9000))
ylabel('Solar Radiation (W/m^2)')
xlabel('Time')
title('Solar Radiation with Apogee Pyranometer');
datetick('x')
grid on





s = 11173; %2014-12-08 23:00:00
e = 18346; %2015-02-21 16:15:00
plot(T(s:e),SDXPress1(s:e))
refline(0,0.8)
xlabel('Time')
ylabel('Water Depth(ft)')
datetick('x','mm/dd/yy')
title('Issue with the SDX Pressure Transducer in the Sediment Bay')
hold on
plot (T1,SDXPress11)


figure(1)
plot(t(s:e),SDXPress2(s:e))
title('Cell 3 Water Table Piezometer')

figure(2)
plot(t(s:e),SDXPress3(s:e))
title('Cell 3 Water Table Piezometer')

figure(3)
plot(t(s:e),SDXPress6(s:e))
title('Cell 1 Stilling Well')


%SDXPress4 and 5 (Cell 3 and Cell 2)
h_out2 = SDXPress5;
h_out3 = SDXPress4;

s = 6532; %2014/10/21 14:45
e = ; %3/26/2015 14:30

figure(1)
plot(T(s:e),h_out2(s:e))
xlabel('Time')
ylabel('Water Level (ft)')
title('Cell 2 and 3 Outlet Water Level Measurement')
hold on

figure(1)
plot(T(s:e),h_out3(s:e))
legend('Cell 2 Outlet','Cell 3 Outlet')
axis([s e 1.35 2])
datetick('x')
hold off
refline(0,1.53);
refline(0,1.5);

figure(6)
bar(T(s:e),Rain(s:e))
title('Precipitation')
xlabel('Time')
ylabel('Precipitation (mm/(15 minutes))')
datetick('x','mm/dd/yy')
