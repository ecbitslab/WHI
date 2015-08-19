%% Script DLT_Driver.m

% Driver script to calibrate multiple cameras using the DLT algorithm given
% by Hedrick and allowing for the use of large scale centroid localization.

% Written by Michael Meaden, Elmhurst College BITS Lab, 4/25/2014.

%% Reinitialize workspace.
close all; clear all; clc;

%% Initialize variables.
% Set threshold and size values to be used in the large scale centroid
% finder within the calibration function.
th = 160;
sz = 19;

% Prompt user to enter how many cameras they wish to calibrate.
cNum = input('How many cameras do you want to calibrate? ');
fprintf('\n');

% Load world coordinate specification file.
% Prompt user to select csv file containing the 3D world coordinates
% corresponding to the image coordinates that will be found.
disp('Select 3D world coordinate specification file.');

% User selects .csv file and the x, y, and z coordinates are stored for
% each point. 
xyz = uigetfile;
[X, Y, Z] = csvimport(xyz, 'columns', {'x','y','z'});
world_coords = [X,Y,Z];

% Get the number of points used for calibration.
npts = size(X,1);
disp(['Loaded a ', num2str(npts), ' point coordinate specification file.']);

% Initialize image coordinate matrix, camera coefficient matrix, and error
% matrix.
im_coords = zeros(npts,2,cNum);
C = zeros(11,cNum);
rmse = zeros(1,cNum);

%% Calibrate each camera by calling the DLTcal_ROI function.
for ii = 1:1:cNum
    close all;
    
    % Tell user which camera is being calibrated.
    fprintf('\n');
    disp(['Begin camera ', num2str(ii), ' calibration.']);
    
    % Call calibration function.
    [im_coords(:,:,ii),C(:,ii),rmse(ii)] = DLTcal_ROI(world_coords,th,sz);
end

%% Save Data in .csv files.
% The image coordinates will be stored in xypts.csv.
% The DLT coefficients will be saved in DLTcoefs.csv.
saveData(im_coords,C,cNum);