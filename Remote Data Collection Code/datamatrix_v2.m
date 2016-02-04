%Grant Livingston
%Created: 10/23/14
%Modified: 11/25/14

%Purpose: Import remotely collected text files, create raw matrix
%% read
clc
clear

%This should be a file with just the headings for the names of the sensors.
sensor_metadata = importdata('X:\incoming\Processed Files\lgr2_normal_headings.csv');

files = dir('X:\incoming\Processed Files\*.txt'); %Import all text file metadata
nfiles =  numel(files); %Number of textfiles in folder

%%%%%%%%%---Import all the textfiles---%%%%%%%%%
h = waitbar(0,'Importing all of the textfiles...');
for i = 1:nfiles; 
    
    name(i,:) = ['X:\incoming\Processed Files\*.txt',files(i).name]; %gets the name of each textfile and stores it as a string
    loggerdata(i,:) = importdata(name(i,:),','); %Imports all data (text and data matrix) from each 
                                             %textfile into all_loggerdata as structural data
                                                 
    %convert loggerdata structure type data to celldata
    celldata(i,:) = struct2cell(loggerdata(i));
    
waitbar(i/(nfiles))
end
close(h)

%%

%Store just the cell data from loggerdata
celldata(:,2) = []; %deletes 2nd column of celldata

%%%%%%%%%---Make the data_matrix---%%%%%%%%%
j=1;
i=1;
h = waitbar(0,'Making the Matrix');
for i = 1:nfiles;
    clear prematdata
    prematdata = cell2mat(celldata(i));
    serial_time = datenum(cell2mat(loggerdata(i).textdata(3)),'yyyy-mm-dd HH:MM:SS');
    prematdata(1,70) = serial_time;    
    
    %the normal case: 1 set of data points for 1 time
    if size(prematdata,1) == 1; %if the number of rows of data is 1
        data_matrix(j,:) = prematdata(1,:);
        %make a new array just containing the current time. will be used for plotting.       
        %current_time(j,:) = datestr(serial_time);
        j=j+1;
        
        
        %needs to be for periods of time that contain 15 minutes only 
        %start 15 minutes - 11/14/14 4:31 am (inclusive)
        %end 15 minutes - 10/3/14 9:46 am (inclusive)
    
    %The special case: more than 1 set of data points and more than 1 time
    elseif size(prematdata,1) > 1
        %take first row in prematdata and add time just like above
            data_matrix(j,:) = prematdata(1,:);
            data_matrix(j,70) = serial_time;
            
            %fix prematdata for assignment dimension mismatch;
            prematdata(1,70) = serial_time;
            %current_time(j,:) = datestr(serial_time);
            
        k=1;
        for k = 1:size(prematdata,1)
            
            %increment time by 15 minutes
            serial_time = addtodate(serial_time,15,'min');
            prematdata(1+k,70) = serial_time;
            
            %update the data matrix
            data_matrix(j+k,:) = prematdata(k+1,:);  
        end
        
        j=j+k;
                   
    end 
    %lookup waitbar function
    waitbar(i/(nfiles-2))
end
close(h)

%Make a copy of the data_matrix
data_matrixcopy = data_matrix;


%%%%%%%%%---Tidy up the data---%%%%%%%%%

%Clean up the the matrix
for i = 1:size(data_matrix,1)
    
    %clean up first column
    if data_matrix(i,1) == 32
        data_matrix(i,1) = NaN();
    end
    
    %Clean up errors in moisture data
    for j = 8:2:46
        if data_matrix(i,j) > 1
            data_matrix(i,j) = NaN();
        end
    end
end   
    
    
    
%Convert time to Julian Time
%Convert it to Matlab's Format
data_matrix(:,70) = data_matrix(:,70) - (datenum('2014-01-01 00:00:00','yyyy-mm-dd HH:MM:SS')-1) %1/1/2014 is day 1, 1/2/2014 is day 2, etc. 


%




