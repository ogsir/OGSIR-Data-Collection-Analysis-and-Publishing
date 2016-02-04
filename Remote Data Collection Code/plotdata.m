%Grant Livingston
%Created: 10/23/14
%Modified: 11/25/14

%Purpose: Use the matrix created by datamatrix_v2.m and titled
%"data_matrix" to start working with the raw data

sensor_metadata = importdata('I:\Grant_Thesis\Data\SensorMeasurementUnits.xlsx')';

%Plot all of the data
plot(data(1:max(time),1),data(1:max(time),4));

%Plot just a section of the data

%What section of data do you want?
section = 2990:3220;
plot(data(section,1),data(section,6));
title('Sensor')
xlabel('Time')
ylabel('Sensor Units')


%%%Inflow vs Outflow Calculations%%%
g = 9.80665; %m/s^2
Cd = 0.6;
theta = 0.3; %radians

%Cell 2 inflow vs outflow

SE1 = data(:,2); %inflow h in ft
SE1 = SE1.*0.3048; %inflow h in m
SE9 = data(:,6); %outflow h in ft
SE9 = SE9.*0.3048; %outflow h in m

%Weir equation q  = 8/15 * Cd * sqrt(2g) * tan(?/2) * h^(5/2)
%Q_in cell 2
Qin_2 = 8/15 * Cd * sqrt(2*g) * tan(theta/2)*SE1.^(5/2) %m^3/s
Qout_2 = 8/15 * Cd * sqrt(2*g) * tan(theta/2)*SE9.^(5/2)

plot(data(3560:3600,1),SE1(3560:3600))


subplot(1,2,1)
plot(data(:,1),Qin_2)
hold on
subplot(1,2,2)
plot(data(:,1),Qout_2)


%Cell 3 inflow vs outflow

%Baseline for SDX's
%The baseline is 1.572 %SDXPress5 = 1.572'

%%%%Code for calculating the baseline of SDX's%%%
%First find a section of data that looks like baseline data
baseline_a = data(section,6);

%Next make a new matrix that removes all of the NaN's 
baseline_b = find(~isnan(baseline_a)); %gives the linear indices of non NaN values in the baseline_a matrix
baseline_c = baseline_a(baseline_b); 

mean(baseline_c)
% 