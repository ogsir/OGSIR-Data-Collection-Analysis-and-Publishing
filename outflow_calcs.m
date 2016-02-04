%Grant Livingston
%Purpose: Outflow Calculation
%Created 1/28/15
%Modified 5/22/15

%Needed:
    %Stage and Discharge variables from thelmar.m must be loaded.  
    
%
%%
%-------------------Start Code for Cell 3 Discharge-------

%Cell 3 Data is collected on the SDXPress4 CR1000 Port

h_out3_mm = h_out3 * 304.8;         %Convert from ft to mm for stage discharge curve

%h_out3_mm = h_out3_m + 4.5 ;       %Add 4.5 mm to h_out3_m for volume
    %balance simulation. 
%
%%
%
%Outflow Discharge Calculations (Using Thel-Mar Weir)

%Apply the interpolated Thelmar rating curve to calculate discharge. 

Q_out3_Lpers = zeros(length(h_out3_mm),1);
for i = 1:length(h_out3_mm)
    if h_out3_mm(i) < 0; %Negative values don't flow. 
        Q_out3_Lpers(i) = 0;
    elseif h_out3_mm(i) > 69;
        Q_out3_Lpers(i) = interp1(stage,discharge,h_out3_mm(i),'linear','extrap'); %L/s
    else
        Q_out3_Lpers(i) = interp1(stage,discharge,h_out3_mm(i)); %L/s    
    end
end

plot(t,Q_in_Lpers,t,Q_out3_Lpers)

%-------------------End code for Cell 3 Discharge-------
%%
%
%%
%------------Begin code for Cell 3 volume outflow-------

%Pre-fill the incremental and cumulative volume vectors
V_out3_Lincremental(1:length(Q_out3_Lpers)) = 0;
V_out3_Lcumulative(1:length(Q_out3_Lpers)) = 0;

%Initialize first value
V_out3_Lincremental(1) = (Q_out3_Lpers(1)+Q_out3_Lpers(2))/2 * 60 * 15; %L out every 15 minutes
V_out3_Lcumulative(1) = V_out3_Lincremental(1); %L

%Make the V_out3_L incremental and V_out3_Lcumulative vectors
for i = 2:(length(Q_out3_Lpers)-1)
    if isnan(Q_out3_Lpers(i));
        V_out3_Lincremental(i) = NaN;
    else
        V_out3_Lincremental(i+1) = (Q_out3_Lpers(i)+Q_out3_Lpers(i+1))/2 * 60 * 15; %L out every 15 minutes
        V_out3_Lcumulative(i) = V_out3_Lcumulative(i-1) + V_out3_Lincremental(i); %L
    end
end

%Fill in the last values
V_out3_Lincremental(end) = (Q_out3_Lpers(end-1)+Q_out3_Lpers(end))/2 * 60 * 15; %L
V_out3_Lcumulative(end) = V_out3_Lcumulative(end-1) + V_out3_Lincremental(end); %L
%%

%Add Evapotranspiration

V_out3_Lincremental_with_ET = V_out3_Lincremental + ET_Cell3; %L
V_out3_Lcumulative_with_ET = V_out3_Lcumulative + ET_cumulative_L; %L


%Flip rows and columns
V_out3_Lincremental = V_out3_Lincremental';
V_out3_Lcumulative = V_out3_Lcumulative';
V_out3_all = V_out3_all';
V_out3_Lcumulative_with_ET = V_out3_Lcumulative_with_ET';

clear W_trench y3 t_TM V_out3_TM

%------------End code for Cell 3 volume outflow-------
%%
%
%
%
%
%
%
%%
%-----------------Start Code for Cell 2 Discharge----------------

%Cell 2 (lgr.SDXPress5) located in the stilling well at the outlet of Cell 2. 

h_weir2 = 1.69291;%ft, physically measured

h_out2 = lgr.SDXPress5 - h_weir2; %ft, height of water behind wier
h_out2 = h_out2 * 304.8; %convert height from ft to mm

%Remove all negative values, which represent elevations in the stilling
%well lower than the v-notch. 
for i = 1:length(lgr.SDXPress5)
    if h_out2(i) < 0;
        h_out2(i) = 0;
    end
end

%Calculate the discharge in Cell 2
Q_out2 = zeros(length(lgr.SDXPress5),1);
for i = 1:length(lgr.SDXPress5)
    Q_out2(i) = interp1(stage,discharge,h_out2(i)); %units of L/s
end

%Convert outflow rate from L/s to ft^3/s
Q_out2 = Q_out2 * 0.0353147;

%Incremental volume outflow in Cell 2 (every 15 minutes)
V_out2 = zeros(length(Q_out2)-1,1);
V_out2(1) = (Q_out2(1)+Q_out2(2))/2 * 15; %First value
for i = 2:length(Q_out2)-1
    V_out2(i) = (Q_out2(i)+Q_out2(i+1))/2 * 15; %Units are L 
end

plot(t(1:end-1),V_out2)
xlabel('Time (days since 1/1/14)');
ylabel('Outflow (L)');
title('Cell 2 Incremental Outflow');

%----------------End code for Cell 2 Discharge---------
%%
