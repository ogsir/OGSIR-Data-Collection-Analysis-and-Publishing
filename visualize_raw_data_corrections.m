%Start of usable data.  October 21 is the first time that the data
%could be used for this project. Everything before Oct. 21
%is crap. 
u = find(strcmpi('2014-10-21 14:30:00',lgr.Time));

%%
%Show how bad the data was
figure(1)
%Convert from ft to mm. Use a datum of 255mm (physically measured in field)
h_inraw = lgr.SDXPress1 * 304.8 - 255; 
plot(T,h_inraw,'blue')
refline(0,0)
xlabel('Time','fontsize',14)
ylabel('Measured Water Depth (mm)','fontsize',14)
title('h_v = h_m_e_a_s_u_r_e_d - 255mm','fontsize',16)
%legend('SDX','Physical Datum')
xlim([T(u) T(end)])
ylim([-300 75])
grid on
datetick('x','keeplimits')

%%
%Give an example of the datum fix
%This can only be run after the drift correction has been
%applied. 

%Bounds for plot
u = T(9715);
w = T(11800);

%Predatum fix
subplot(2,1,1)
plot(T,h_inraw,'blue')
ylabel('h_v (mm)','fontsize',14)
title('h_v Physically Measured.  h_v = h_m_e_a_s_u_r_e_d - 255mm','fontsize',16)
xlim([u w])
refline(0,0)
grid on
datetick('x','keeplimits')

%Postdatum Fix
subplot(2,1,2)
plot(T,need_variable_here,'blue') %enter y variable from drift corrected data. 
ylabel('h_v (mm)','fontsize',14)
xlabel('Time','fontsize',14)
title('h_v Drift Corrected. h_v = h_m_e_a_s_u_r_e_d - datum','fontsize',16)
refline(0,0)
h_in_datums_mm = h_in_datums*304.8;
hold on
for i = 5:length(h_in_datums_mm)
    s = t(datstarth_in(i));
    e = t(datendh_in(i));
    plot(T(s:e),h_in_raw(s:e),'green','LineWidth',4);
    hold on
end
xlim([u w])
datetick('x','keeplimits')
grid on

%clear unused variables
clear u w h_inraw