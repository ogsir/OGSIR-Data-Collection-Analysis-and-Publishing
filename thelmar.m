%Purpose: Develope a stage discharge relationship for the thel-mar weirs
%using the given tables and linear interpolation. 
%Created 1/28/15
%Modified 5/23/15

%------Start Code for THEL-MAR WEIR STAGE DISCHARGE Curve--------------

%stage in mm, discharge in L/s. Data provided by Thel-Mar. 

stage = [0,5,7,9,11,13,15,17,19,21,23,25,27,29,31,33,35,37,39,41,43,45,47,49,51,53,55,57,59,61,63,65,67,69];
discharge = [0,0.002498371,0.005040904,0.011394084,0.020327652,0.032201221,0.046617324,0.063878794,0.083947776,0.106899978,0.132842655,0.161624389,0.19356694,0.226070994,0.24329461,0.313394094,0.385815296,0.460558217,0.537622855,0.617015521,0.698723596,0.782753389,0.869111209,0.957790747,1.04817372,1.146487127,1.246510277,1.349820425,1.455326111,1.563103042,1.674608603,1.78799425,1.904534406,2.023882075];

x = 0:69;
y1 = interp1(stage,discharge,x);
y2 = interp1(stage,discharge,x,'spline');
x = 0:150;
y3 = interp1(stage,discharge,x,'linear','extrap'); %L/s
%diff = y2-y1;

%plot(x,y3,'-o')
plot(stage,discharge,'-o')
title('Thel-Mar Rating Curve')
xlabel('Stage (mm)')
ylabel('Discharge (L/s)')
grid on

clear x y1 y2 diff
%------End Code for THEL-MAR WEIR STAGE DISCHARGE Curve--------------
%
%
%
%----------Thel-Mar Weir Time to Drain Model----------


dt =   1;                             %s, Change in time
t_TM = 1:dt:86400;                    %the time vector (864000s = 1 day)
por = 0.4;                            %porosity of 3/4in round river rock
D_pipe = 0.4;                         %ft; diameter of the underdrain pipe. Model this as a rectangle for now
W_trench = 16/12;                     %ft; width of the trench that the underdrain pipe is in
L_trench = 93.4;                      %ft; length of the trench
A_trench = L_trench*W_trench*por;     %ft^2
A_pipe = D_pipe * L_trench;           %ft^2

A = A_trench + A_pipe;                %ft^2
A = A*0.092903;                       %m^2 


%Initialize vectors
V_out3_TM(1:length(t_TM)) = 0;
V_out3_TM = V_out3_TM';
Q_out3_TM(1:length(t_TM)) = 0;
Q_out3_TM = Q_out3_TM';
h(1:length(t_TM)) = 0;
h = h';


h(1) = 69; %Start with water level at the top of Thel-Mar weir.

for i = 1:length(t_TM);
    
    Q_out3_TM(i) = interp1(stage,discharge,h(i));   %L/s, flow rate over TM weir
    V_out3_TM(i) = Q_out3_TM(i) * dt;               %L, Volume of water that passed over TM weir in 1 timestep
    V_out3_TM(i) = V_out3_TM(i)/1000 ;              %Convert volume to m^3
    h(i) = h(i)/1000;                               %convert h from mm to m
    h(i+1) = h(i) - V_out3_TM(i)/A;                 %m height at the next time step due to loss of volume of water
    
    h(i) = h(i)*1000;                               %convert h from m back to mm
    h(i+1) = h(i+1)*1000;                           %convert h from m back to mm
end

%clear h

t_TM = t_TM/3600; %convert from s to hr

subplot(2,1,1)
plot(t_TM,h(1:length(h)-1)); %Plot of the Thel-Mar Recession Curve Model
xlabel('Time (hrs)')
ylabel('Water Depth Behind Weir (mm)')
title('Thel-Mar Recession Curve Model. Assumes no additional inputs during draining')
grid on
grid minor

%Calculate the slope of the recession curve
for i = 1:length(h)-1
    slope(i) = (h(i+1)-h(i))/(1/60);
end


subplot(2,1,2)
plot(t_TM,slope)
xlabel('Time (hrs)')
ylabel('dh/dt (mm/min)')
title('Slope of the Outflow Recession Curve')
grid on
grid minor
