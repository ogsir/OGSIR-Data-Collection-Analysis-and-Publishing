%Grant Livingston
%Created 5/24/15        
%Modified 5/24/15  
%Show how calibration can be used to improve the volume balance.

%%
%-----------------------Start Calibration Code------------------
%Description:
    %Calibrate inflow with pumping rate of 0.75 L/s, which corresponds to a
    %water height of 0.07m behind the weir.
    %Calibrate outflow with volume balance
        %Volume balance
        % V_in - V_out = delta_S
        % V_pumped + V_precip - V_underdrain - V_ET = V_wet_s - V_wet_e

%Storm intervals in stormcal_s and stormcal_e
%Storm start
stormcal_s(1) = find(strcmpi('2014-10-24 00:00:00',lgr.Time)); %Storm 1
stormcal_s(2) = find(strcmpi('2014-12-27 00:00:00',lgr.Time)); %Storm 2
stormcal_s(3) = find(strcmpi('2015-03-30 12:00:00',lgr.Time)); %Storm 3
%Storm end
stormcal_e(1) = find(strcmpi('2014-10-28 00:00:00',lgr.Time)); %Storm 1
stormcal_e(2) = find(strcmpi('2014-12-31 00:00:00',lgr.Time)); %Storm 2
stormcal_e(3) = find(strcmpi('2015-04-03 12:00:00',lgr.Time)); %Storm 3
%
%%
%--------Start Inflow Calibration------------
%
%
%Calibrate around the inflow height for pump rate
%Pump rate is 0.75 L/s. Corresponding height is 0.07m (70mm, 7cm)
h_in_m_cal = h_in_m; %m, sediment bay v-notch weir height

%h_weir needs to be shifted up by this vector
pumpcal = [0.002 0.002 0.002]; %mm


%Choose how you want to apply the height calibration. 

%Apply the height calibration to three storms
% for i = 1:3
%     s = stormcal_s(i);
%     e = stormcal_e(i);
%     h_in_m_cal(s:e) = h_in_m_cal(s:e) + pumpcal(i);
% end

%Apply the height calibration to all data 
h_in_m_cal = h_in_m_cal + 0.002;


%
%View the height calibrations
% for i = 1:3
% plot(T,h_in_m_cal)
% xlim([T(stormcal_s(i)) T(stormcal_e(i)) ])
% ylim([0.05 0.08])
% datetick('x',2,'keeplimits')
% refline(0,0.07)
% grid on
% grid minor
% pause
% end
%
%
%
%Apply the calibrated height vector to the inflow rate
c_d = 0.6;                    %Coefficient of discharge
g = 9.807;                    %m/s^2
theta = pi/4;                 %angle of v-notch

Q_in_Lpers_cal = Q_in_Lpers; %L/s
for i = 1:length(h_in_m_cal)
    if h_in_m_cal(i) < 0;
        Q_in_Lpers_cal(i) = 0;
    else
        Q_in_Lpers_cal(i) = (8/15*c_d*sqrt(2*g)*tan(theta/2).*h_in_m_cal(i).^(5/2)).*1000; %L/s
    end
end
%
%View the flow calibrations
% for i = 1:3
% plot(T,Q_in_Lpers_cal)
% xlim([T(stormcal_s(i)) T(stormcal_e(i)) ])
% ylim([0 0.85])
% datetick('x',2,'keeplimits')
% refline(0,0.75) %Measured pumping rate
% grid on
% grid minor
% pause
% end
%--------End Inflow Calibration---------
%
%
%%
%--------Start Outflow Calibration---------

%Volume balance: Units used will be L. 
% V_in - V_out = delta_S
% V_pumped + V_precip - V_underdrain - V_ET = V_wet_s - V_wet_e

%Initialize Variables
Q_out3_Lpers_cal = Q_out3_Lpers; %L/s

%%
%Soil Storage Changes
% %Volume facility (soil and pore space, not above ground)
% V_fac_L = 93.4*10.55*1.8*28.3168 %L
% 
% %Show Changes in Storage
% for i = 1:3
%     s = stormcal_s(i);
%     e = stormcal_e(i);
%     delta_S(i) = (mean(mean(wet3(e:e+8,1:8)))-mean(mean(wet3(s:e+8,1:8)))) * V_fac_L; %L
%     subplot(3,1,i)
%     plot(T,wet3);
%     ylabel('Soil Moisture Eqv.')
%     xlim([T(s) T(e)])
%     ylim([0.2 0.7])
%     datetick('x',2,'keeplimits')
%     grid on
% end
% xlabel('Time','Fontsize',14)
% subplot(3,1,1)
% title('Fall, Winter, and Spring Soil Moisture','FontSize',16)
%%
% %Storm Volume Balance
% for i = 1:3
%     s = stormcal_s(i);
%     e = stormcal_e(i);
%     
%     V_Pumped(i) = trapz(Q_in_Lpers_cal(s:e))*60*15; %L/(15min); Integrate for volume
%         
%     V_precip = 0;
%     V_precip = cumsum(P_L(s:e)); %L, Cumulative Precip
%     V_Precip(i) = V_precip(end); %Save total cumulative volume from storm event
%     
%     V_et = 0;
%     V_et = cumsum(ET_Cell3(s:e)); %L, Cumulative ET
%     V_ET(i) = V_et(end); %L, Save total cumulative volume from storm event
%     
%     V_Underdrain(i) = trapz(Q_out3_Lpers_cal(s:e))*60*15; %L/(15min); Integrate for volume
%         
%     lhs(i) = V_Pumped(i) + V_Precip(i) - V_Underdrain(i) - V_ET(i);
%     rhs(i) = delta_S(i)
%     
% end
% %
% lhs = lhs';
% rhs = rhs';
% V_Pumped = V_Pumped';
% V_Precip = V_Precip';
% V_ET = V_ET';
% V_Underdrain = V_Underdrain';
%
%%
%Calibrate the outflow using the volume balance
%
%Initialize variable for adjustment
h_out3_mm_cal = h_out3_mm;
%
underdrain_cal = [7 7.8 5.7]; %mm %height changes for h_out3_mm_cal
%
%Choose the period of time you want to apply the height calibration to
%Apply the height calibration to just the three storms
%
% for i = 1:3
%     s = stormcal_s(i);
%     e = stormcal_e(i);
%     h_out3_mm_cal(s:e) = h_out3_mm_cal(s:e)+ underdrain_cal(i); %mm, Calibrated heigh
% end
%
%Apply the height calibration to each season. 
for i = 1:3
    s = datestr(season_s(i),31); %int
    s = find(strcmpi(s,lgr.Time)); %int
    
    e = datestr(season_e(i),31); %int
    e = find(strcmpi(e,lgr.Time)); %int
    
    h_out3_mm_cal(s:e) = h_out3_mm_cal(s:e)+ underdrain_cal(i); %mm, Calibrated heigh
end
%
%
%Calculate discharge and volume with calibrated height
%
%Initialize vector
%
Q_out3_Lpers_cal = Q_out3_Lpers; %L/s
for i = 1:length(lgr.Time)
    if h_out3_mm_cal(i) <= 0;
        Q_out3_Lpers_cal(i) = 0;
    elseif h_out3_mm_cal(i) > 69;
        Q_out3_Lpers_cal(i) = interp1(stage,discharge,h_out3_mm_cal(i),'linear','extrap'); %L/s
    else
        Q_out3_Lpers_cal(i) = interp1(stage,discharge,h_out3_mm_cal(i)); %L/s    
    end
    
end
%
% %
% %Calculate the volume to check for target
% for i = 1:3
% 
%     s = stormcal_s(i);
%     e = stormcal_e(i);
%     
%     V_Underdrain(i) = trapz(Q_out3_Lpers_cal(s:e))*60*15; %L; Integrate for volume
%         
%     n(:,i) = isnan(h_out3_mm_cal(s:e));
%     m(:,i) = isnan(Q_out3_Lpers_cal(s:e));
%     
%     
% end
% 
% V_Underdrain = V_Underdrain';

%--------End Outflow Calibration---------

