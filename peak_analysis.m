%Purpose: Calculation of Inflow/
%Created 5/24/15
%Modified 5/24/15

%Purpose: Find Peaks, then analyze them statistically
%
%%
%------------------Start Find peaks-----------------
%%
%------Calibrate the peak finder
%
clear out3_PKS out3_LOCS T_out3_LOCS in_PKS in_LOCS T_in_LOCS
%

%Two methods to find peaks: 
%   1.by using the inflow peaks as the set point and searching around 
%       it to find its matched outflow peak
%   2.by using the outflow peaks as the set point and searching around 
%       it to find its matched outflow peak
%
%
%--Method 1: Find peaks by outflow peaks

%Adjust this peakfinder to adjust the sensitivity of which peaks are
%selected
[out3_PKS,out3_LOCS] = findpeaks(Q_out3_Lpers_cal,...
    'MinPeakHeight',0.1, 'MinPeakDistance',4,'MinPeakProminence',0.05);
%'MinPeakHeight',0.14, 'MinPeakDistance',4);
%
for i = 1:length(out3_LOCS)
    s = out3_LOCS(i)- 6;
    e = out3_LOCS(i);
    
    %search in every 6 adjacent data points for 2 matching peaks
    
    [in_pks, in_loks] = max(Q_in_Lpers_cal(s:e));
    
    in_PKS(i) = in_pks; %make a vector of inflow peaks
    in_LOCS(i) = (s + in_loks - 1); %make a vector of the time-locations
                                    %of inflow peaks in the in_PKS vector
    
end
out3_PKS = out3_PKS';
put3_LOCS = out3_LOCS';
%
%
%--Method 2: Find peaks by inflow peaks
% clear out3_PKS out3_LOCS T_out3_LOCS in_PKS in_LOCS T_in_LOCS
% [in_PKS,in_LOCS] = findpeaks(Q_in_Lpers_cal,...
%     'MinPeakHeight',0.75/2, 'MinPeakDistance',4);
% for i = 1:length(in_LOCS)
%     s = in_LOCS(i);
%     e = in_LOCS(i)+ 4;
%     [out3_pks, out3_loks] = max(Q_out3_Lpers_cal(s:e));
%     out3_PKS(i) = out3_pks;
%     out3_LOCS(i) = (s + out3_loks-1);
% end
% out3_PKS = out3_PKS';
% put3_LOCS = out3_LOCS';
%
%%
%
%%
figure(1)
%Plot the peaks
for i = 1:3
    
    s = stormcal_s(i);
    e = stormcal_e(i);
    T_in_LOCS = T(in_LOCS);
    
    T_out3_LOCS = T(out3_LOCS);
    T_out3_LOCS_time = cellstr(datestr(T_out3_LOCS));
    
    subplot(3,1,i)
    plot(T,Q_in_Lpers_cal,'-k', T,Q_out3_Lpers_cal,'--k')
    hold on
    plot(T_in_LOCS,in_PKS,'o','MarkerEdgeColor','k')
    hold on
    plot(T_out3_LOCS,out3_PKS,'o','MarkerEdgeColor','k')
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
title('Drift Corrected & Calibrated Fall, Winter, and Spring Storms. 96 Hours Each','FontSize',16)
leg = legend('Inflow, Sed. Bay Weir','Outflow, Underdrain Weir');
set(leg,'FontSize',14,'Location','NorthEast')
%
%
%------------------End Find peaks-----------------
%%
%
%
%%
%
%-------------Start Calculating ALL Peak Statistics------------
%Peak Delay
pk_delay = (T_out3_LOCS-T_in_LOCS)*24*60;%min
%figure;histogram(pk_delay,0:15:90);
%
%Peak Ratio
pk_ratio = out3_PKS./in_PKS;
pk_ratio = pk_ratio';
%
%Remove peak ratio values that are from drain tests
for i = 1:length(pk_ratio)
    if pk_ratio(i) > 2
        pk_ratio(i) = NaN;
    end
end
figure(4)
subplot(2,1,1)
histogram(pk_ratio)

subplot(2,1,2)
normplot(pk_ratio)

figure(5)
subplot(2,1,1)
histogram(pk_delay)
subplot(2,1,2)
normplot(pk_delay)

%
%-------------End Calculating ALL Peak Statistics------------
%%
%
%
%%
%-------------Start Calculating SEASONAL Peak Statistics------------
%
%--Use this to analyze peaks seasonally
%Ref http://www.usno.navy.mil/USNO/astronomical-applications/data-services/earth-seasons
%Fall 2014
season_s(1) = datenum('2014-10-21 14:45:00');
season_e(1) = datenum('2014-12-21 23:00:00');
%Winter 2014-2015
season_s(2) = datenum('2014-12-21 23:15:00');
season_e(2) = datenum('2015-03-20 22:45:00');
%Spring 2015
season_s(3) = datenum('2015-03-20 23:00:00');
season_e(3) = datenum('2015-05-15 18:15:00'); %Must make this one 15 minutes early or code below doesn't work
%
% %--Use this to analyze peaks for 3 storms
% %Fall 2014
% season_s(1) = datenum('2014-10-24 00:00:00');
% season_e(1) = datenum('2014-10-28 00:00:00');
% %Winter 2014-2015
% season_s(2) = datenum('2014-12-27 00:00:00');
% season_e(2) = datenum('2014-12-31 00:00:00');
% %Spring 2015
% season_s(3) = datenum('2015-03-30 12:00:00');
% season_e(3) = datenum('2015-04-03 12:00:00');
% %
%%
%
%Make s_pks vector (integer for season start)%
%Initialize variables
s_pks = [1 1 1]; %Location of change of season for all 3 seasons 
j=1;
%
for i = 2:3
    %All time
    j = find(T_out3_LOCS>season_s(i),1);
    s_pks(i) = j-1;
end
%
%Make e_pks vector (integer for season start)
%Initialize variables
e_pks = [1 1 length(T_out3_LOCS)]; %Location of change of season for all 3 seasons
j=1;
for i = 1:2
    %All time
    j = find(T_out3_LOCS>season_e(i),1);
    e_pks(i) = j;
end

%Number points in each season or storm
n = [e_pks(1) e_pks(2)-e_pks(1) e_pks(3)-e_pks(2)];

%--------------------Start Calculate & Plot Stats-------------
for i = 1:3
    s = s_pks(i);
    e = e_pks(i);
    
    figure(2)
    subplot(3,1,i)
    histogram(pk_ratio(s:e),0:0.1:1.4);
    pk_ratio_mean(i) = nanmean(pk_ratio(s:e));
    pk_ratio_median(i) = nanmedian(pk_ratio(s:e));
    pk_ratio_max(i) = max(pk_ratio(s:e));
    pk_ratio_min(i) = min(pk_ratio(s:e));
    pk_ratio_stdev(i) = nanstd(pk_ratio(s:e));
    
    figure(3)
    subplot(3,1,i)
    histogram(pk_delay(s:e),0:15:90)
    pk_delay_mean(i) = nanmean(pk_delay(s:e));
    pk_delay_median(i) = nanmedian(pk_delay(s:e));
    pk_delay_max(i) = max(pk_delay(s:e));
    pk_delay_min(i) = min(pk_delay(s:e));
    pk_delay_stdev(i) = nanstd(pk_delay(s:e));
end
%
%
%Peak Ratio Figures
figure(2)
%Fall
subplot(3,1,1)
ylabel('Frequency','FontSize',14)
str = sprintf('Fall 2014 Peak Ratio Histogram, n = %d',n(1));
title(str,'FontSize',16);
grid on

%Winter
subplot(3,1,2)
ylabel('Frequency','FontSize',14)
str = sprintf('Winter 2014/2015 Peak Ratio Histogram, n = %d',n(2));
title(str,'FontSize',16);
grid on

%Spring
subplot(3,1,3)
xlabel('Peak Ratio (Q_p_k_-_o_u_t/Q_p_k_-_i_n)','FontSize',14)
ylabel('Frequency','FontSize',14)
str = sprintf('Spring 2015 Peak Ratio Histogram, n = %d',n(3));
title(str,'FontSize',16);
grid on
%
%
%Peak Delay figures
figure(3)
%Fall
subplot(3,1,1)
ylabel('Frequency','FontSize',14)
str = sprintf('Fall 2014 Peak Delay Histogram, n = %d',n(1));
title(str,'FontSize',16);
grid on

%Winter
subplot(3,1,2)
ylabel('Frequency','FontSize',14)
str = sprintf('Winter 2014/2015 Peak Delay Histogram, n = %d',n(2));
title(str,'FontSize',16);
grid on

%Spring
subplot(3,1,3)
xlabel('Peak Delay (min)','FontSize',14)
ylabel('Frequency','FontSize',14)
str = sprintf('Spring 2015 Peak Delay Histogram, n = %d',n(3));
title(str,'FontSize',16);
grid on

%--------------------End Calculate & Plot Stats-------------
%
%-------------End Calculating SEASONAL Peak Statistics------------
%
%
%
%
%
%
%
% %Abandonded Code
%
%
% for i = 1:length(s)
%     [Min,Iin] = max(Q_in(s(i):e(i)));
%     [Mout,Iout] = max(Q_out3(s(i):e(i)));
%     R_peak(i) = 1 - Mout/Min; % percent reduction
%     R_delay(i) = (Iout-Iin)*15/60; ; %hrs
% end
% R_peak = R_peak';
% R_delay = R_delay';
% 
% 
% for i = 1:10;
% plot(t,wet3(:,i));
% pause
% end
% 
% 
% %Storm 2
% 
% trapz(Q_in(s:e))*60*15 - trapz(Q_out3(s:e))*60*15 % (ft^3) volume balance 
% 
% subplot(3,1,3)
% plot(T(s:e),wet3(s:e,:))
% axis([T(s) T(e) 0.3 0.7 ])
% title('Soil Moisture')
% xlabel('Time')
% ylabel('Soil Moisture %')
% datetick('x','keeplimits')
% legend('A','B-West','B-East','C','D','E','F','G','H','I')
% mean((wet3(e,[2 3 6 9]))-(wet3(s,[2 3 6 9])))
% 
% 
% 
% 
% subplot(3,1,1)
% bar(T(s:e),P(s:e,:))
% axis([T(s) T(e) 0 0.03])
% datetick('x','keeplimits')
% title('Precipitation')
% xlabel('Time')
% ylabel('Direct Precipitation (CFS)')
% grid minor
% 
% for i = 1:length(s)
%     [Min,Iin] = max(Q_in(s(i):e(i)));
%     [Mout,Iout] = max(Q_out3(s(i):e(i)));
%     R_peak(i) = 1 - Mout/Min; % percent reduction
%     R_delay(i) = (Iout-Iin)*15/60; ; %hrs
% end
% R_peak = R_peak';
% R_delay = R_delay';
% 
% %Storm 3
% plot(t(s:e),wet3(s:e,:))
% legend('A','B-West','B-East','C','D','E','F','G','H','I')
% (wet3(e,[2 3 6 9]))-(wet3(s,[2 3 6 9]))
% 
% for i = 1:length(s)
%     [Min,Iin] = max(Q_in(s(i):e(i)));
%     [Mout,Iout] = max(Q_out3(s(i):e(i)));
%     R_peak(i) = 1 - Mout/Min; % percent reduction
%     R_delay(i) = (Iout-Iin)*15/60; ; %hrs
% end
% R_peak = R_peak';
% R_delay = R_delay';
% 
% %--------End Outflow Calibration---------
% 
% 
% %Storm 1
% % s = [6800 6850 6920 6925 6940 6950 6970 7020];
% % e = [6850 6910 6925 6930 6950 6970 6990 7030];
% 
% %Storm 2
% %s = [10110 10140 10160 10190 10240];
% %e = [10140 10160 10190 10220 10260];
% 
% %Storm 3
% % s = [23235 23282 23320 23328];
% % e = [23250 23300 23327 23332];