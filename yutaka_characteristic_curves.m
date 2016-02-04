% Plot Precipitation for December.
%NEED TO FIX ALL HARD CODES

s = 3000;
e = 14172;

figure(1)
plot(T(s:e),P(s:e));
title('Precipitation')
xlabel('Time (days)')
ylabel('Precipitation (in/hr)')
datetick('x','mm/dd/yy')

figure(2)
plot(T(s:e),wet3((s:e),1:4));
title('Soil Moisture')
xlabel('Time (days)')
ylabel('Soil Moisture Content)')
datetick('x','mm/dd/yy')
legend('1','2','3','4')

figure(3)
s = 4500;
e = 6000;
plot(T(s:e),wet3((s:e),4));
title('Soil Moisture')
xlabel('Time (days)')
ylabel('Soil Moisture Content)')
datetick('x','mm/dd/yy')
legend('1','2','3','4')


figure(4)
plot(wet3((s:e),1),tensio(s:e,5));
title('Soil Water Characteristic Curve')
xlabel('Soil Moisture Content')
ylabel('Pressure (cm H2O)')

figure(4)
plot(T(s:e),tensio(s:e,8));
title('Soil Water Characteristic Curve')
xlabel('Time (days)')
ylabel('Pressure (cm H2O)')
datetick('x','mm/dd/yy')

figure(4)
hold on
s = 12000
e = 14172
plot(wet3((s:e),1),tensio(s:e,5));
title('Soil Water Characteristic Curve')
xlabel('Soil Moisture Content')
ylabel('Pressure (cm H2O)')

