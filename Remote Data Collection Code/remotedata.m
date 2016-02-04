clear;
clear all;
clc;
%% http://www.mathworks.com/matlabcentral/answers/27212-textscanning-and-exporting-several-text-files
tic;
cd('X:/incoming/');                         % set current folder      
DataTable = fopen('Processed Files/DataTable.csv','a');            % open csv for writing; append to end of file
Log = fopen('Processed Files/Log.txt','a');
if exist('Processed Files/oldfiles.mat','file')             % File exists.  Do stuff....
    load('Processed Files/oldfiles.mat');                   % open txt file metadata from previous run
    files = dir('*.txt');                                   % get current txt file metadata
    files = sortrows(struct2table(files),'datenum');        % convert current into more readable format (table) and sort by date
    newfiles = setdiff(files,oldfiles);                     % locate only the new txt files
else                                                        % File does not exist.
    fprintf(Log,'%s %s\n',datestr(now,'yyyy-mm-dd HH:MM:SS'),'No directory record. Starting new record: check data table for repeated entries')
    newfiles = dir('*.txt');                                % get current txt file metadata
    newfiles = sortrows(struct2table(newfiles),'datenum');  % convert current into more readable format (table) and sort by date
end
if ~isempty(newfiles)                                       %
fprintf(Log,'%s %d %s\n',datestr(now,'yyyy-mm-dd HH:MM:SS'),size(newfiles,1),' new file(s)')
    for n=1:size(newfiles,1)                            % loop through all new txt files in incoming directory
        %http://www.mathworks.com/matlabcentral/answers/81115-how-to-read-every-nth-line-with-textscan
        txt = fopen(char(newfiles.name(n)),'r');           % open txt file
        
        for m=1:2                                       % skip 2 headerlines
            tline = fgets(txt);
        end
        
        while ischar(tline)                             % Write third line to main csv
            tline = fgets(txt);
            fprintf(DataTable,'%s',tline);
            
            for m=1:2                                   % Skip next two lines
                tline = fgets(txt);
            end
        end
        
        fclose(txt);
        
    end
    
    if (exist('files','var'))==1
        oldfiles = files;
    else     
        oldfiles = newfiles;
    end    
    clearvars newfiles files;
    save('Processed Files/oldfiles.mat','oldfiles');
    save('J:\OGSIR\Data','oldfiles');
    fprintf(Log,'%s %s\n',datestr(now,'yyyy-mm-dd HH:MM:SS'),'DataTable updated')
   
else
    fprintf(Log,'%s %s\n',datestr(now,'yyyy-mm-dd HH:MM:SS'),'No new files: check data logger')
end

fclose(DataTable);
fclose(Log);

t2=toc;

fprintf('Program took %f sec\n',t2)

clearvars fid1 fid2 m n ans tline txt t2;

open('Processed Files/Log.txt')

exit
%eof