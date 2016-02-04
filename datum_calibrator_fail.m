%Trying to pick out the flat areas for datum correction. 
%Currently, this is a fail


slope(1:length(lgr.Time)) = NaN;
for i = 1:(length(lgr.Time)-1)
    
   slope(i) = (h_in(i+1)-h_in(i))/15*60;
end


plot(t,slope,'-o')

slopediff = 
for i = 1:length(slope)
slopediff(i) = slope(i)-slope(i+1);
end

plot(t,slopeavg,'o-')


k = 1;
i = 1;
j = 1;
while i <= length(slope)
    if ~isnan(slope(i))
        while abs(slope(i)) > 0.004 
            i = i+1;
            j = 1;
            if i == 26322;
                break
            end
        end

        while abs(slope(i)) <= 0.004
            j=j+1;
            if j == 16;
                dat_s(k) = i-20;
                dat_e(k) = i;
                j = 1;
                k = k+1;
                break
            end
            i = i+1;
            if i == 26322;
                break
            end
        end
    end
    
   i = i+1;
            if i == 26322;
                break
            end
    
end

plot(t,h_in)
hold on
for i = 1:length(dat_s)
    if dat_s(i) < 0
        dat_s(i) = 1;
    end
    if dat_e(i) < 0
        dat_e(i) = 1;
    end   
    
    plot(t(dat_s(i):dat_e(i)),h_in(dat_s(i):dat_e(i)));
    hold on
end
