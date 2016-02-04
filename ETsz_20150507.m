%% Ref_ET.m
% version 2015.05.01.1600

% This code calculates net ET (mm/hr H2O) using
% ASCE Standardized Reference Evapotranspiration Equation (2005)
% (Combined ASCE Penman-Monteith) at 15-minute intervals
% from site geometry, sensor data, and empirical estimates
% using some expanded-form equations as noted

% Sensor data points are taken to be at the midpoint of the time period 
% during which they are used as a basis of calculation.

clc;
clear;

%% -- Load and prep data for input into functions -------------------------

% -- Load variables from cleaned-up data file -----------------------------

% load('K:\Thesis\Evapotranspiration\dataimport.csv');
% can't get this to work...just load it by hand ("Import Data") for now

% -- Convert time to Matlab Time ------------------------------------------

% Convert time to Serial Time

T = datenum(Time);

% Convert time to Julian Time

T = T - (datenum('2014-01-01 00:00:00','yyyy-mm-dd HH:MM:SS')-1); % 1/1/2014 is day 1, 1/2/2014 is day 2, etc.
T(9212:length(Time)) = T(9212:length(Time))-365;                  % reset: 1/1/2015 is day 1, 1/2/2015 is day 2, etc.

% Create a variable of integer time for plotting purposes
% (this will tell you what row to edit in your Excel spreadsheet if you see errors)

t = (1:size(Time))';

% -- View the Data, Check for Errors --------------------------------------

plot(T,AirTmp)      %deg. C
datetick('x','keeplimits')

plot(t,BarPress)    % atmospheric pressure at 15-min intervals (milliBars)

plot(t,NetRad_Wm2)  % incoming solar radiation at 15-min intervals (W/m^2)

plot(t,RelHum)      % relative humidity at 15-min intervals (%)

plot(t,WndSpd)      % wind speed at 15-min intervals (m/s)

%% -- Calculations --------------------------------------------------------

%% -- Parameters and functions --------------------------------------------

% -- Unit conversions -----------------------------------------------------

Kfm = 0.0348;                     % meters per foot (m/f)
Ksh = 3600;                       % seconds per hour (s/h)
Kl = 1000;                        % (mm/m)
KmbkP = 0.1;                      % kiloPascals per milliBar (kPa/mbar)
Kdr = pi/180;                     % radians per degree (rad/deg)

% -- Fundamental and Measured Constants -----------------------------------

k = 0.41;                         % Von Karman constant
R = 287;                          % specific gas constant (J/kg/K)
sigma = 56.70*10^-9;              % Stephan-Boltzmann constant (W/m^2/K^4)
cp = 1.1013*10^(-3);              % specific heat of moist air (MJ/kg/degC)
rhoW = 998.2;                     % density of water (kg/m^3)
Gsc = 4.92;                       % solar constant (MJ/m^2/h)

% Constants for alternative formulations

% (Needed only for mean Press backup calc)
% Po = = 101.3;                     % atmospheric pressure at sea level  (kPa)
% z0 = 0;                           % elevation at reference level (i.e., sea level) (m)
% g = 9.807;                        % gravitational acceleration (m/s^2) 
% alpha1 = 0.0065;                  % constant lapse rate of moist air (K/m)

% eps = 0.622;                      % ratio of the molecular weight of water vapor/dry air (“epsilon”) for standard, dry air

% -- Site parameters (collected) ------------------------------------------

zw = 5.18;                        % height of wind measurements (m)
zh = 5.18;                        % height of humidity measurements (m)
        %(this is outside of the acceptable range but we'll just have to run with it for now--CSC 5/8/2015)
z = 68;                           % height of site above mean sea level (m)
lat = 44.551456;                  % latitude of site  (deg)
phi = lat*Kdr;                    % latitude of site (rad)
t1 = 0.25;                        % data collection time interval (h)
Lz = 120;                         % longitude of the center of the local (Pacific) time zone (deg, +west from Greenwich)
Lm = 123.269289;                  % longitude of the site (deg, +west from Greenwich)

% -- Time-varying (vector) data (collected on site) -----------------------

Tair = AirTmp;                    % avg air temp over time period (degC)
TairK = Tair + 273.15;            % avg air temp over time period (K)
Rn = NetRad_Wm2;                  % avg net solar radiation???????????????????????????? (W/m^2)
RHair =  RelHum;                  % avg relative humidity over time period (%)
Press = BarPress * KmbkP;         % avg atmospheric pressure over time period (kPa)
uz = WndSpd;                      % avg wind speed at height z (m/s)

% ------- Time-varying data (empirical estimates) -------------------------

h = 0.012;                        % mean height of vegetation (m) must be
                                  % estimated at either standardized short ref
                                  % surface (0.012m) or tall ref surface (0.5m)
                                  % We could try to create better (time-varying) estimate and import, but that
                                  % would require a code rewrite to use full ASCE Penman-Monteith rather than
                                  % the ASCE simplified reference ET.
d = 2/3*h;                        % zero plane displacement height (m) (citation?)
zom = 0.123*h;                    % roughness length governing momentum transfer (m)  (citation?)
zoh = 0.1*zom;                    % roughness length hv governing heat/vapor transfer (m)  (citation?)

% TK0 = calculate mean temp at sea level
                                  % need this only for Press if sensor goes down
    
%% -------------------- Subroutines ---------------------------------------

%% -- 1. Latent heat of vaporization -------------------------------- (p27)

lambda = 2.45;                      % latent heat of vaporization for water (MJ/kg)

% simplified from:                    % (EqB.7, pB-7)
%
% lambda = 2.501-(2.361.*10.^(-3)).*Tair
%                                     % latent heat of vaporization for water (MJ/kg)
%                                     % (Harrison 1963)

% %% -- 2. Atmospheric pressure ------------------------------- (Eq34, p28)
% (use if pressure sensor goes down)
%
% Press = 101.3*((293-0.0065*z)/293)^5.26
%                                     % mean atmospheric pressure calculated 
%                                     % from elevation and universal gas law (kPa)

%% -- 3. Psychrometric constant ------------------------------- (Eq35, p28)

gamma = 0.000665.*Press;            % Psychrometric constant (kPa/degC)
                                    
% simplified from:                    % (EqB.12, pB-8)
%
% gamma = cp*Press/(eps*lambda)       % Psychrometric constant (kPa/degC)
%                                     % (Brunt 1952)

%% -- 4. Slope of the saturated vapor press-temp curve -------- (Eq36, p28)

Delta = 2504.*exp(17.27.*Tair./(Tair+237.3))./((Tair+237.3).^2);
                                    % slope of saturation vapor pressure versus temperature (kPa/degC)

%% -- 5. Saturation vapor pressure ---------------------------- (Eq37, p29)

es = 0.6108.*(exp(17.27.*Tair)./(Tair+237.3));
                                    % saturated vapor pressure of the air (kPa)

%% -- 6. Actual vapor pressure sub-calculation ---------------- (Eq41, p32)

ea = (RHair./100).*es.*Tair;      % actual vapor pressure of the air calculated from relative humidity (kPa)

%% -- 7. Net radiation calculations --------------------------------- (p32)
% % -- 7.1 Net solar (shortwave) radiation ---------------------------- (p33)
% % -- 7.1.1 Albedo sub-calculation ----------------------------------- (p33)
% 
% alb = 0.23;                         % albedo--assumed: standardized grass/alfalfa ref surface (dimensionless ratio)
%                                     % could try to create better (time-varying) estimate and import
% 
% % -- 7.1.2 Net solar (shortwave) radiation -------------------- (Eq43, p33)
% 
% Rns =(1-alb).*Rs;                   % (W/m^2, +down)
% 
% % -- end of 7.1 subcalculations --------------------------------%%%%%%%%%%%
% 
% 
% % -- 7.2 Net terrestrial (longwave) radiation ----------------------- (p33) (after the method of Brunt (1932, 1952))
% % -- 7.2.1 Clear-sky solar radiation -------------------------------- (p37)                                 
% % -- 7.2.1.1 Extraterrestrial radiation ----------------------------- (p39)
% % -- 7.2.1.1.1 Julian day ------------------------------------------- (p40)
% 
% J = fix(T);                         % Julian day of the year (extracted from decimal timestamp)
% 
% % -- 7.2.1.1.2 Solar declination ------------------------------ (Eq51, p39)
% 
% declin = 0.409.*sine(2.*pi./365.*J-1.39); %(rad)
% 
% % -- 7.2.1.1.3 Earth-sun distance factor ---------------------- (Eq50, p39)
% 
% dr = 1+0.033.*cos(2.*pi./365.*J);   % inverse relative distance factor (squared) for the earth-sun (unitless)
% 
% % -- 7.2.1.1.4 Solar time angle at midpoint of period --------------- (p40)
% % -- 7.2.1.1.4.1 Standard clock time at midpoint of the period ------ (p41)
% 
% timoday = (T-J)*24;                 % decimal time of day extracted from timestamp (hrs)
% 
% % -- 7.2.1.1.4.2 Seasonal correction for solar time ----------- (Eq57, p42)
% 
% b = 2.*pi.*(J-81)/364;              % some constant (rad)
% 
% Sc = 0.1645*sin(2*b)-0.1255*cos(b)-0.025*sin(b); % dimensionless correction to convert standard noon (12pm) to local noon (sun at highest point)
% 
% % -- 7.2.1.1.4.3 Solar time angle at midpoint of period ------- (Eq53, p40)
% 
% omega = pi./12.*((timoday+0.06667.*(Lz-Lm)+Sc)-12);
%                                     % projected angle of sun east or west of site (rad)
% 
% % -- end of 7.2.1.1.4 subcalculations --------------------------%%%%%%%%%%%
% 
% 
% % -- 7.2.1.1.5 Sunset hour angle ---------------------------- (Eq59, p42)
% 
% omegaS = pi/2-arccos(-tan(phi)*tan(declin));
%                                     % projected angle of sunset west of site (rad)
% 
% % -- 7.2.1.1.6 Solar time angle at beginning of period -------- (Eq53, p40)
% 
% omega1 = omega-pi.*t1./24;          % projected angle of sun east or west of site (rad)
% 
% % -- 7.2.1.1.7 Solar time angle at end of period -------------- (Eq54, p40)
% 
% omega2 = omega-pi.*t1./24;          % projected angle of sun east or west of site (rad)
% 
% % -- 7.2.1.1.8 Correct bounds for nighttime time angles ------- (Eq56, p41)
% 
% omega1(omega1<-omegaS) = -omegaS;   % sets any predawn solar time angle to the solar time angle of dawn (rad)
% omega2(omega2<-omegaS) = -omegaS;   % sets any predawn solar time angle to the solar time angle of dawn (rad)
% omega1(omega1>omegaS) = omegaS;     % sets any postsunset solar time angle to the solar time angle of sunset (rad)
% omega2(omega2>omegaS) = omegaS;     % sets any postsunset solar time angle to the solar time angle of sunset (rad)
% omega1(omega1>omega2) = omega2;     % sets any beginning solar time angle that appears to be later than 
%                                     % the end solar time angle to the end solar time angle (rad)
% 
% % -- 7.2.1.1.9 Extraterrestrial radiation --------------------- (Eq48, p39)
% 
% Ra = 12/pi.*Gsc.*dr.*((omega2-omega1).*sin(phi).*sin(declin)+cos(phi).*cos(declin).*(sin(omega2)-sin(omega1)));
%                                     % solar radiation above the atmosphere (MJ/m^2/h)
% 
% % -- end of 7.2.1.1 subcalculations ----------------------------%%%%%%%%%%%
% 
% 
% % -- 7.2.1.2 Clear-sky solar radiation ------------------------ (Eq47, p37)
% 
% Rso = (0.75+2e-5.*z).*Ra;           % avg clear-sky solar radiation over period of evaluation (W/m^2, +down)
%                                     % standard simplified approach: for more
%                                     % accurate method see Appendix D Eq. D.1-D.5
% 
% % -- end of 7.2.1 subcalculations ------------------------------%%%%%%%%%%%
% 
%                                     
% % -- 7.2.2 Cloudiness function -------------------------------- (Eq45, p35)
%                                      % describes relationship of measured solar radiation Rs 
%                                      % to modeled clear-sky solar radiation Rso
%                                      % for calculation of net long-wave radiation
%                                      
% final = length (Rs);                 % set number of loop iterations as the number of field data points
% for i = 1:3                          % workaround for first three timestamps (can't do averaging method used in all successive steps)
%     if 0.3<=Rs(i)/Rso(i)             % sets validity condition: at night Rs0=0 and ratio is undefined;
%                                      % below 0.3 (i.e. when sun is less than 0.3 radians above horizon) large measurement errors occur.
%                                      % (Eq46, p35)
%         fcd = 1.35*Rs(i)/Rso(i)-0.35;% cloudiness function: limited to 0.05<=fcd<=1.0
%     else
%         fcd = 0.5;                   % sets cloudiness function at minimum possible value (p35)
%     end
% end
% 
% for i = 4:final                      % main conditional relationship
%     if 0.3<=Rs(i)/Rso(i)             % sets validity condition: at night Rs0=0 and ratio is undefined;
%                                      % below 0.3 large measurement errors occur.
%                                      % (Eq46, p35)
%         fcd = 1.35*Rs(i)/Rso(i)-0.35;% cloudiness function: limited to 0.5<=fcd<=1.0
%     else
%         if 0.3<=Rs(i-1)/Rso(i-1)
%             fcd = (fcd(i-1)+fcd(i-2)+fcd(i-1))/3; 
%                                      % sets cloudiness function as average of the final three valid values (p33)
%         else
%             fcd = fcd(i-1);          % repeats set average until fcd>0.3 again (i.e. sun above 0.3 radians in the morning)
%         end                          % !!This part of the method concerns me since we generally have clouds evening to morning in our area
%     end                              % (see discussion p36)
% end
% 
% % -- 7.2.3 Net terrestrial (longwave) radiation --------------- (Eq44, p34)
% 
% Rnl = sigma.*fcd.*(0.34-0.14.*ea.^0.5).*(TairK.^4);   
%                                     % (using near surface vapor pressure to predict net surface emissivity)(MJ/m2/d, +up)
% 
% % -- end of 7.2 subcalculations --------------------------------%%%%%%%%%%%
% 
% 
% % -- 7.3 Finally: Net radiation ------------------------------- (Eq42, p32)
% 
% Rn = Rns-Rnl;                       % (MJ/m2/d, +down)
%                             
%% -- 8. Soil heat flux density ---------------------------- (Eq65-66, p44)

if h == 0.12                        % standardized height of a short reference surface (m)
    if (Rn > 0)                        % standardized definition of daytime by net radiation (p44)
        G = 0.1.*Rn;                   % daytime hourly-or-less soil heat flux density for a short reference surface (s/m)
    else
        G = 0.5.*Rn;                   % nighttimetime hourly-or-less soil heat flux density for a short reference surface (s/m)
    end
elseif h == 0.50                   % standardized height of a tall reference surface (m)
    if (Rn > 0)                        % standardized definition of daytime by net radiation (p44)
        G = 0.04*Rn;                   % daytime hourly-or-less soil heat flux density for a tallreference surface (s/m)
    else
        G = 0.2*Rn;                    % nighttimetime hourly-or-less soil heat flux density for a tall reference surface (s/m)
    end
else
    warning('Vegetation height input must match short or tall reference surface--or else you need to go back to the references and do aome major fiddling. Probably end up using the full ASCE Penman-Monteith.')
end

%% -- 9. Wind profile relationship ---------------------------- (Eq67, p44)

u2 = uz*4.87/ln(67.8*zw-5.42)       % empirical relationship of wind at measurement height to wind at 2m (for standardized equation)

%% -- 10. Variable coefficients for the simplified ETsz ------ (Table1, p5)

if h == 0.12                        % standardized height of a short reference surface (m)
    if (Rn > 0)                        % standardized definition of daytime by net radiation (p44)
        Cn = 37;                       % ETsz numerator coefficient
        Cd = 0.24;                     % ETsz denominator coefficient
    else
        Cn = 37;                       % ETsz numerator coefficient
        Cd = 0.24;                     % ETsz denominator coefficient
    end
elseif h == 0.50                   % standardized height of a tall reference surface (m)
    if (Rn > 0)                        % standardized definition of daytime by net radiation (p44)
        Cn = 66;                       % ETsz numerator coefficient
        Cd = 0.25;                     % ETsz denominator coefficient
    else
        Cn = 66;                       % ETsz numerator coefficient
        Cd = 0.25;                     % ETsz denominator coefficient
    end
else
    warning('Vegetation height input must match short or tall reference surface--or else you need to go back to the references and do aome major fiddling. Probably end up using the full ASCE Penman-Monteith.')
end

%% -- 10. Bulk surface resistance sub-computation ------------ (Table2, p5)

if h == 0.12                        % standardized height of a short reference surface (m)
    if (Rn > 0)                        % standardized definition of daytime by net radiation (p44)
        rs = 50;                       % daytime hourly-or-less bulk surface resistance (s/m)
    else
        rs = 200;                      % nighttime hourly-or-less bulk surface resistance (s/m)
    end
elseif h == 0.50                   % standardized height of a tall reference surface (m)
    if (Rn > 0)                        % standardized definition of daytime by net radiation (p44)
        rs = 30;                       % daytime hourly-or-less bulk surface resistance (s/m)
    else
        rs = 200;                      % nighttime hourly-or-less bulk surface resistance (s/m)
    end
else
    warning('Vegetation height input must match short or tall reference surface--or else you need to go back to the references and do aome major fiddling. Probably end up using the full ASCE Penman-Monteith.')
end

% I'm sure I'll eventually have to do it the hard way for my thesis, to get variable heights.



% -------- Aerodynamic resistance sub-computation ----------

ra = (log((zw-d)./zom).*log((zh-d)./zoh))./k.^2.*uz;
                                  %aerodynamic resistance (s/m)

%% -- Reference ET Total calculation (mm/hr) -------------------- (Eq1, p4)
%  (with time interval correction (p27))

ETsz = t1.*(0.408.*Delta.*(Rn-G)+gamma.*Cn./(Tair+273).*u2.*(es-ea))./(Delta+gamma.*(1+Cd.*u2));

So there.

eof