%Created 1/8/15
%Purpose: To compare inflow and outflow data

%3. %%%%%PRESSURE TRANSDUCERS%%%%
%Convert ft to mm (all raw data in ft)
SDXPress1 = SDXPress1 * 304.8; %Subtract 0.79ft to have all data converted to have 0 = bottom of v-notch). 
SDXPress2 = SDXPress2 * 304.8;
SDXPress3 = SDXPress3 * 304.8;
SDXPress4 = SDXPress4 * 304.8;
SDXPress5 = SDXPress5 * 304.8;
SDXPress6 = SDXPress6 * 304.8;

%Sediment Bay Pressure Transducer.
%All PT data
subplot(2,1,2)
plot(t,SDXPress1)
xlabel('Time (days since 1/1/14)');
ylabel('Depth (mm)');
title('Sediment Bay Pressure Transducer Raw Data');
axis([0,7200,225,325])
grid on

%December Data
subplot(4,1,2)
plot(Time(3642:6616),SDXPress1(3642:6616))
xlabel('Time (days since 1/1/14)')
ylabel('Depth (mm)');
title('Sediment Bay Pressure Transducer Raw Data for December 2014');

%2 Storms
subplot(2,1,2)
plot(Time(3900:4500),SDXPress1(3900:4500))
xlabel('Time (days since 1/1/14)')
ylabel('Depth (mm)');
title('Sediment Bay Pressure Transducer Raw Data: Dec. 4th - 7th');
grid on
grid minor

%play
subplot(2,1,2)
plot(Time(4000:4200),SDXPress1(4000:4200))
xlabel('Time (days since 1/1/14)')
ylabel('Depth (mm)');
title('Sediment Bay Pressure Transducer Raw Data: Dec. 4th - 7th');
grid on
grid minor
axis([0 7200 230 265])

%%%%%CELL 2 STILLING WELL PIEZOMETER%%%%
%Labeled SDXPress5

plot(t,SDXPress5,'.')
subplot(4,1,3)
plot(t(3642:6616),SDXPress5(3642:6616))
xlabel('Time (days since 1/1/14)')
ylabel('Depth (mm)');
title('Cell 2 Raw Data for December 2014');

%%%%%CELL 3 STILLING WELL PIEZOMETER%%%%
%Labeled SDXPress4

plot(t,SDXPress4,'.')
subplot(4,1,4)
plot(t(3642:6616),SDXPress4(3642:6616))
xlabel('Time (days since 1/1/14)')
ylabel('Depth (mm)');
title('Cell 3 Raw Data for December 2014');


%%%%%RAIN%%%%%
%all rain data
bar(Time,Rain)
xlabel('Time (days since 1/1/14)');
ylabel('P (mm/15 minutes)');
title('Precipitation Data');

%December Precipitation Data
subplot(4,1,1)
plot(Time(3642:6616),Rain(3642:6616))
xlabel('Time (days since 1/1/14)');
ylabel('P (mm/15 minutes)');
title('December Precipitation Data');

%Two Storms
subplot(2,1,1)
plot(Time(3900:4500),Rain(3900:4500))
xlabel('Time (days since 1/1/14)');
ylabel('Precipitation (mm/15 minutes)');
title('Precipitation: Dec. 4th - 7th');
grid on
grid minor

%play
subplot(2,1,1)
plot(Time(4100:4500),Rain(4100:4500))
xlabel('Time (days since 1/1/14)');
ylabel('Precipitation (mm/15 minutes)');
title('Precipitation: Dec. 4th - 7th');
grid on
grid minor

%%%%%WEATHER
%Air Temp
plot(Time(3900:4500),AirTmp(3900:4500))
xlabel('Time (days since 1/1/14)');
ylabel('Air Temperature (Deg. C)');
title('Precipitation: Dec. 4th - 7th');




