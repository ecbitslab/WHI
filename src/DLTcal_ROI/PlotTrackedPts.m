%% Script PlotTrackedPts.m

%% Summary
% Prompts user to select .csv file containing 3D Tracked coordinate data.
% Plots the indicated points in 3D.

%% LOAD COORDINATE DATA INTO WORKSPACE BEFORE PROCEEDING! %%%%%%%%%%%%%%%%%

% Save data to matrix D.
D = untitled;

% Specify points tracked per frame.
ppf = 12;

% Specify frame to display.
frames = [4 34 46 255];

for jj = 1:1:size(frames,2)
    % Select frame.
    frame = frames(jj);
    
    % Plot x, y, and z coordinates in 3D.
    figure;
    for ii = 1:1:ppf
        plot3(D(frame,(ii-1)*3+1),D(frame,(ii-1)*3+2),D(frame,(ii-1)*3+3),'ob'); hold on;
    end

    grid on;
end
