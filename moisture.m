%Soil Moisture Data
%Modified 5/11/15
%NEED TO FIX ALL HARD CODES


%Tensiomark Error Checking

plotyy(T,tensio(:,2))

%%%%-------------------Soil Moisture-----------------%%%%

%---------Make array for cell 2 moisture data-----------
%This array is ordered from the perspective of looking at the facility on
%the south side looking Northin.  Then it goes, ABC DEF GHI, just as in the
%instrumentation diagram.

%verified
wet2 = [lgr.Moisture8, lgr.Moisture7, lgr.Moisture6, lgr.Moisture5, lgr.Moisture11, lgr.Moisture10, ...
    lgr.Moisture9, lgr.Moisture17, lgr.Moisture15, lgr.Moisture16];


%---------Make array for cell 3 moisture data-----------

%verified
wet3 = [lgr.Moisture4, lgr.Moisture3, lgr.Moisture1, lgr.Moisture2, lgr.Moisture12, lgr.Moisture13, lgr.Moisture14, ...
    lgr.Moisture20, lgr.Moisture19, lgr.Moisture18];

%Get rid of all the extra variables
clear Moisture1 Moisture2 Moisture3 Moisture4 Moisture5 Moisture6 ...
    Moisture7 Moisture8 Moisture9 Moisture10 Moisture11 Moisture12 Moisture13 ...
    Moisture14 Moisture15 Moisture16 Moisture17 Moisture18 Moisture19 Moisture20

%Clean up sensors with unreal moisture data: sensors 13,17,20
%Cell 3 sensors 13 and 17
for i = 1:length(lgr.Time)
        if wet3(i,6) > 1
            wet3(i,6) = NaN;
        end
end
for i = 1:length(Time)
    if wet3(i,8) > 1
        wet3(i,8) = NaN;
    end
end

for j = [8]; %Cell 2 sensor 8
    for i = 1:length(Time)
    if wet2(i,j) > 1
        wet2(i,j) = NaN;
    end
    end
end



%------------------Tensiometers-------------

%Key
%pF1 - 2C
%pF2 - 2A
%pF3 - 3A
%pF4 - 3B- West
%pF5 - 3C
%pF6 - 3B-East
%pF7 - 2B-East
%pF8 - 2B-West

%Tensiometer matrix
%Set up to be read from left to right for ease. 
%Verified.
tensio = [pF2, pF8, pF7, pF1, pF3, pF4, pF6, pF5] ;

clear pF2 pF8 pF7 pF1 pF3 pF4 pF6 pF5

%convert to hPA, then to cm H2O
tensio = 10.^(tensio).*1.01971621298;

%Remove bad data from Cell2BWest
for i = 1:numel(T)
    if tensio(i,2) > 500
        tensio(i,2) = NaN;
    end
end

s = 11000;
e = 17000;
plotyy(T(s:e),tensio(s:e,6),T(s:e),Rain(s:e))
%legend('Cell 2A', 'Cell 2BWest', 'Cell 2BEast', 'Cell 2C', 'Cell 3A', 'Cell 3BWest', 'Cell 3BEast', 'Cell3C')
datetick('x','keeplimits')

%Problem sensors:


%----Animation--------
s = 9000
plot(wet2((s:e),4),tensio(s:e),4,'-')
title('Soil Water Characteristic Curve')
xlabel('Soil Moisture Content (Vw/Vs)')
ylabel('Pressure (pF)')
hold on

for i = (8000):e
    plot(wet2((i),3),pF7(i),'.')
    xlim([0.25,0.65])       %Horizontal axis limit
    ylim([0,1])        %Vertical Axis limit
    hold on
    pause(0.001) %Pause for 0.02 seconds before continuing
end



%-----------End Tensiometers---------------



%Plot sensors in Cell 2
s = 955;
e = 10500;







for i = 1:10
plot(T(s:e),wet2((s:e),i))
ylabel('Volumetric Water Content (V_w/V_s)');
xlabel('Time (Days)');
title('All Soil Moisture Sensors');
hold on
end
datetick('x','mm/dd/yy')
legend('2A','2B-West','2B-East','2C','2D','2E','2F','2G','2H','2I')
hold off
grid on

%------Plot sensors by location-----
%Location 2A,B_E,B_W,C
[AX,H1,H2] = plotyy(T(s:e),P(s:e),T(s:e),wet2((s:e),1),'bar'...
    ,'line','Color',[1 1 1],'Color',[0 0 1])
set(get(AX(1),'Ylabel'),'String','Precipitation (in/hr)')
%set(AX(1),'YDir', 'reverse') 
set(H2,'Color',[1 0 0])
set(AX(1),'YLim',[0,6])
set(AX(1),'YTick', [0:0.5:6]);
set(get(AX(1),'Xlabel'),'String','Time')
set(get(AX(2),'Ylabel'),'String','Soil Moisture (V_water/V_soil)')
title('Precipitation and Cell 2 Moisture Data');
xlabel('Time')
datetick('x','mm/dd/yy')

hold on

%Add all the other sensors
p3 = plot(AX(2),T(s:e),wet2((s:e),2));
p4 = plot(AX(2),T(s:e),wet2((s:e),3));
p5 = plot(AX(2),T(s:e),wet2((s:e),4));

legend([H1,H2,p3,p4,p5],'Precipitation','2A','2B_West','2B_East','2C')


plot(t,wet(:,8))
%datetick('x','mm/dd/yy')


%Clean up the bad cell data
for i = 1:lenth(Time)
    if Moisture9(i) = NaN;
       Moisture9(i) = NaN();
    end
end



Moisture9 = cell2mat(Moisture9)


s = 1000;
e = 14172;

%Cell 2 %5,6,7,8,9,10,11,15,16,17

plot(t(s:e),Moisture1(s:e))

plot(T(s:e),Moisture5(s:e),T(s:e),Moisture6(s:e),T(s:e),Moisture7(s:e),T(s:e),Moisture8(s:e),...
    T(s:e),Moisture9(s:e)),T(s:e),Moisture10(s:e),T(s:e),Moisture11(s:e),T(s:e),Moisture15(s:e),...
    T(s:e),Moisture16(s:e),T(s:e),Moisture17(s:e))

plot(T(s:e),Moisture9(s:e))

%Cell 3 %1,2,3,4,12,13,14,18,19,20

plot(T(s:e),Moisture1(s:e),T(s:e),Moisture2(s:e),T(s:e),Moisture3(s:e),T(s:e),Moisture4(s:e),...
    T(s:e),Moisture12(s:e),T(s:e),Moisture13(s:e),T(s:e),Moisture14(s:e),T(s:e),Moisture18(s:e),...
    T(s:e),Moisture19(s:e),T(s:e),Moisture20(s:e))