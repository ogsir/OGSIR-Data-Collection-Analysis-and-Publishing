%Grant Livingston
%Created 5/25/15        
%Modified 5/25/15  
%Purpose: Error Analysis for 3 Storms. 

%Need a high and low error ranged based on manufacturers error for pressure transducers 

%--------Start Inflow Calculations of Error Analysis------------
%
%low and high error range for sediment bay v-notch weir
h_in_m_errlow = h_in_m_cal - 0.0038; %m, based on manufacturer
h_in_m_errhigh = h_in_m_cal + 0.0038; %m, based on manufacturer
%
%Apply the low and high error height vector to find the flowrate
c_d = 0.6;                    %Coefficient of discharge
g = 9.807;                    %m/s^2
theta = pi/4;                 %angle of v-notch

Q_in_Lpers_errlow = Q_in_Lpers_cal; %L/s
Q_in_Lpers_errhigh = Q_in_Lpers_cal; %L/s
for i = 1:length(h_in_m_errlow)
    if h_in_m_errlow(i) < 0;
        Q_in_Lpers_errlow(i) = 0;%L/s 
    else
        Q_in_Lpers_errlow(i) = (8/15*c_d*sqrt(2*g)*tan(theta/2).*h_in_m_errlow(i).^(5/2)).*1000; %L/s
    end
    
    if h_in_m_errhigh(i) < 0;
        Q_in_Lpers_errhigh(i) = 0;%L/s 
    else
        Q_in_Lpers_errhigh(i) = (8/15*c_d*sqrt(2*g)*tan(theta/2).*h_in_m_errhigh(i).^(5/2)).*1000; %L/s
    end
    
end
%
%--------End Inflow Calculations for Error Analysis---------
%
%
%%
%--------Start Outflow Calculations for Error Analysis----------

%Initialize Variables
h_out3_mm_errlow = h_out3_mm_cal - 3.8; %mm
h_out3_mm_errhigh = h_out3_mm_cal + 3.8; %mm
%
%Calculate discharge
%
%Initialize vector
Q_out3_Lpers_errlow = Q_out3_Lpers_cal; %L/s
Q_out3_Lpers_errhigh = Q_out3_Lpers_cal; %L/s
%
for i = 1:length(lgr.Time)
    %Error Low
    if h_out3_mm_errlow(i) <= 0;
        Q_out3_Lpers_errlow(i) = 0;%L/s 
    elseif h_out3_mm_errlow(i) > 69;
        Q_out3_Lpers_errlow(i) = interp1(stage,discharge,h_out3_mm_errlow(i),'linear','extrap'); %L/s
    else
        Q_out3_Lpers_errlow(i) = interp1(stage,discharge,h_out3_mm_errlow(i)); %L/s    
    end
    
    %Error High
    if h_out3_mm_errhigh(i) <= 0;
        Q_out3_Lpers_errhigh(i) = 0;%L/s 
    elseif h_out3_mm_errhigh(i) > 69;
        Q_out3_Lpers_errhigh(i) = interp1(stage,discharge,h_out3_mm_errhigh(i),'linear','extrap'); %L/s
    else
        Q_out3_Lpers_errhigh(i) = interp1(stage,discharge,h_out3_mm_errhigh(i)); %L/s    
    end
    
end
%
%--------End Outflow Calculations for Error Analysis----------
%
%
figure(1)
%Plot the peaks
for i = 1:3
    
    s = stormcal_s(i);
    e = stormcal_e(i);
    
    subplot(3,1,i)
    plot(T,Q_in_Lpers_cal,'-k',T,Q_out3_Lpers_cal,'--k')
    hold on
    plot(T,Q_in_Lpers_errlow,'-k',T,Q_out3_Lpers_errlow,'--k')
    hold on
    plot(T,Q_in_Lpers_errhigh,'-k',T,Q_out3_Lpers_errhigh,'--k')
    hold off
    xlim([T(s) T(e)])
    ylim([0 0.85])
    ylabel('Flowrate (L/s)','FontSize',14)
    datetick('x',2,'keeplimits')
    grid on
    grid minor

end
hold off
xlabel('Time','FontSize',14)
subplot(3,1,1)
title('Error Analysis Fall, Winter, and Spring Storms. 96 Hours Each','FontSize',16)
leg = legend('Inflow, Sed. Bay Weir','Outflow, Underdrain Weir');
set(leg,'FontSize',14,'Location','NorthEast')

