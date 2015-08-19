function saveData(xypts,coefs,cNum)

%% Summary of function saveData.m

% Saves the image coordinate data obtained by the script DLTcal_ROI.m and
% the corresponding DLT coefficients in respective files 'xypts.csv' and
% 'DLTcoefs.csv'. Saves the data in a format that is compatible with the
% Hedrick DLT GUI.

% INPUT:
% coords:  Matrix of xy image coordinates used in DLT calibration.
%
% C:  Camera matrix coefficients calculated from the DLT calibration
%     procedure.
%
% cNum: Number of cameras calibrated.

% OUTPUT:
% No variable output.  Saves data to respective .csv files.

% Written by Michael Meaden, Elmhurst College BITS Lab, 4/24/2014.

%% Main Code Block

 % get a place to save it
    pname=uigetdir(pwd,'Pick a directory to contain the output files');
    pause(0.1); % make sure that the uigetdir ran (MATLAB bug workaround)
    
    % get a prefix
    pfix=inputdlg({'Enter a prefix for the data files'},'Data prefix',...
      1,{'cal01_'});
    if numel(pfix)==0
      return
    else
      pfix=pfix{1};
    end
    
    % test for existing files
    if exist([pname,filesep,pfix,'xypts.csv'],'file')~=0
      overwrite=questdlg('Overwrite existing data?', ...
        'Overwrite?','Yes','No','No');
    else
      overwrite='Yes';
    end
    
    % create headers (xypts)
    xyh=cell(cNum*2,1);
    for i=1:cNum
      xyh{i*2-1}=sprintf('cam%s_X',num2str(i));
      xyh{i*2}=sprintf('cam%s_Y',num2str(i));
    end
    
    if strcmp(overwrite,'Yes')==1
      % xypts
      f1=fopen([pname,filesep,pfix,'xypts.csv'],'w');
      % header
      for i=1:numel(xyh)-1
        fprintf(f1,'%s,',xyh{i});
      end
      fprintf(f1,'%s\n',xyh{end});
      % data
      for i=1:size(xypts,1);
        tempData=squeeze(xypts(i,:,:));
        for j=1:numel(tempData)-1
          fprintf(f1,'%.6f,',tempData(j));
        end
        fprintf(f1,'%.6f\n',tempData(end));
      end
      fclose(f1);
      
      % dltcoefs
      dlmwrite([pname,filesep,pfix,'DLTcoefs.csv'],coefs,',');
      
%      uda.recentlysaved=1;
%      set(h(1),'Userdata',uda); % pass back complete user data
      
      msgbox('Data saved.');
    end