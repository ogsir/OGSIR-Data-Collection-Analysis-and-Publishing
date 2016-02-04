%Created: 12/13/14
%Modified: 3/28/15
%Purpose: Make my own peak finder instead of using MatLab's built in one. 
%Could potentially also be used for automation of the the data calibration

%%NEED TO FIX ALL HARD CODES

%Matlab's Peak Finder
[pks,locs,w,p] = findpeaks(SDXPress4)
figure(1)
plot(locs,pks,'*',t,SDXPress4)

figure(2)
peakfinder(SDXPress4,.05,.82,1,false)
plot(peakLoc,Peakmag,'*',t,SDXPress4)

figure(2)
plot(t,SDXPress4)
axis([4000 17324 1.5 1.8])

plot(t,Rain)
axis([4000 17324 1.5 1.8])



%Purpose: This code was created to define a storm event.  There are two different methods: 

%1.Use the minimum value that the raingauge detects as the beginning of a storm event. End this storm event when raingauge has 0 reading. 

%2 USe the pumptime.  The pumptime is difficult to define because of the moving baseline. 

%Results from 1: T.Test: Average length of storm is 41.5 minutes (p <0.0001). 95% CI average is between 32.0 minutes and 51.1 minutes. 

%Results from 2: Based on the data and some assumptions about when the pump is on and when it is off, the average length of a storm is 17.7 hours, p-value = 0.015, 95% CI: 3.63 to 31.84 hrs. The median length of a storm is 2.5 hours. 


%---------Storm Event Trigger based on pump turning on----

l = length(SDXPress1)
Q_in = SDXPress1;

%Q_in is the sediment basin pressure transducer returning height in feet.  The number subtracted from Q_in is the general height of the water in the Q_in after a pumping session has completed, which is assumed to be the water height at the bottom of the v-notch weir and above the pressure transducer.  In all reality this number is probably around 0.8, but I am not sure of the true value. I am not sure how to carry that variability through the rest of the calculations either. 

Q_in = Q_in - 0.79; %Subtract water level below Vee


%--Determine when pump is on and when it is off
pump = zeros([l 1]); %Initialize vector
for i = 1:l
  if Q_in(i) > 0 
      pump(i) = 1 ;
  else pump(i) = 0 ;
  end
end

%--Determine length of each pumping event (pumptime)
pumptime = zeros([l 1]);

%First point
pumptime(1) = 0; #check

for i = 2:l
  if pump(i) == 1
    pumptime(i) = 1 + pumptime(i-1);
  else pumptime(i) = 0;
  end
end


%--Makes pumptimetot a vector that just has total pumptime numbers 
%for each event and zeros

pumptimetot = zeros([l 1]);
pumptimetot(1) = 0; #check
for i = 2:l 
  if pumptime(i) == 0 %This searches for the end of an event
      pumptimetot(i) = pumptime(i-1);
  else pumptimetot(i) = 0;
      
  end
end


%--Makes pumptimetot a vector that just has pumptime numbers 
%without the zeros for statistical purposes
for i = 1:l
    if pumptimetot(i) == 0;
        pumptimetot(i) = NaN;
    end
end

%Now run any statistical tests

%----------End Code for Storm Event Trigger based on pump turning on-----------



%----------Defining a storm event by a finite increase in water level in the sediment bay---

l = length(SDXPress1);
Q_in = SDXPress1;       %sediment bay logger data
trigger = 0.88;         %ft minimum measurement to start event
triggerC = 0.825;       %ft measurement to continue slow events
noise = 5*.0025;        %ft size of the noise


%--Populate the storm on/off vector--
storm = zeros([l 1]);
j = 2; %Initialize the timestep.  Sometimes use j-1, so need to start at 2.

        h = waitbar(0,'Populating the Stormtime Vector');
        for i=1:1000,
            % computation here %
            waitbar(i/l,h)
        end
        
h = waitbar(0,'Populating the Stormtime Vector');
while j < l  
    
  while j < l %Go to the next value without NaN
      if isnan(Q_in(j));
          j = j + 1;
      else
          break
      end
  end
  
  
  %Check to see if water level is near the bottom of the v-notch. If it is, than an event will be triggered.  
    if Q_in(j) >= trigger %an event triggered by a measurement spike
    storm(j) = 1; %Storm is on
    j = j + 1; %Next time step

      %The storm continues
      while Q_in(j) >= triggerC %this is a safety factor to make sure the storm continues
        if j == l %safety to make sure loop breaks if we get to the end
            break 
        end 
        %Ride the wave!
        storm(j) = 1; %Storm is continues
        j = j + 1; %Increment time
        
          %check to see if the storm is finishing
          if Q_in(j) < triggerC 
              %Find difference between the previous data point and the current data point 
              diff = abs(Q_in(j-1) - Q_in(j));
%               diff2 = abs(Q_in(j) - Q_in(j+1));
%               diff3 = abs(Q_in(j-1) - Q_in(j));
%               diff4 = abs(Q_in(j-1) - Q_in(j));
              %If the difference is less than the noise, then the storm is over
              if diff < noise   
                storm(j) = 0; 
              end
         end
      end
     end
     
    
    while Q_in(j) < trigger %Case that storm never started
      if j == l %safety to make sure loop breaks if we get to the end 
         break 
      end
      storm(j) = 0; %if the sediment bay water level was never near the v-notch, then no storm was occuring
      j = j+1; %increment time
    end
    
    waitbar(i/l,h)
end


   
%--Plotting
s = 9300;
e = 10225;

max(Q_in(9400:10225))

subplot(2,1,1)
plot(t(s:e),Q_in(s:e),'-*')
refline(0,0.8)
%datetick('x','mm/dd/yy')

subplot(2,1,2)
bar(T,storm)
axis([s e 0 1])



%--Discretize Events

%
%--Determine length of each pumping event (pumptime)
pumptime = zeros([l 1]);

%First point
pumptime(1) = 0; #check
%Cumulative pumptime vector
for i = 2:l
  if pump(i) == 1
    pumptime(i) = 1 + pumptime(i-1);
  else pumptime(i) = 0;
  end
end

%--Makes pumptimetot a vector that just has total pumptime numbers 
%for each event and zeros

pumptimetot = zeros([l 1]); %initialize vector
pumptimetot(1) = 0; #check %First point
for i = 2:l 
  if pumptime(i) == 0 %This searches for the end of an event
      pumptimetot(i) = pumptime(i-1);
  else pumptimetot(i) = 0;
      
  end
end



%--Makes pumptimetot a vector that just has pumptime numbers 
%without the zeros for statistical purposes
for i = 1:l
    if pumptimetot(i) == 0;
        pumptimetot(i) = NaN;
    end
end
%
