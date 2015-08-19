%% Script extract_frames.m

% Script to extract frames from a video (avi) file.

%% BEFORE BEGINNING, LOAD XYpts COORDINATE FILE! %%%%%%%%%%%%%%%%%%%%%%%%%%
xycoords = untitled;

%% Load avi files.
% Left camera video.
vL = mmreader('cam1_2014-06-30-141621-0000.avi');
vidL = vL.read();

% Right camera video.
vR = mmreader('cam1_2014-06-30-141622-0000.avi');
vidR = vR.read();

%% Create vector of frame numbers to grab.
frames = [4 34 46 255];

%% Specify number of points per frame that are tracked.
ppf = 12;

%% Plot frames without tracked points indicated.
for ii = 1:1:size(frames,2)
    figure;
    imshow(vidL(:,:,:,frames(ii))); hold on;
    figure;
    imshow(vidR(:,:,:,frames(ii))); hold on;
end

%% Plot frames with tracked points indicated.
for ii = 1:1:size(frames,2)
    figure;
    imshow(vidL(:,:,:,frames(ii))); hold on;
    
    % Plot tracked points on left camera frames.
    for jj = 1:1:ppf
        plot(xycoords(frames(ii),(jj-1)*2+1),xycoords(frames(ii),(jj-1)*2+2),'oc');
    end
    
    figure;
    imshow(vidR(:,:,:,frames(ii))); hold on;
    
    % Plot tracked points on right camera frames.
    for kk = 1:1:ppf
        plot(xycoords(frames(ii),(kk-1)*2+1),xycoords(frames(ii),(kk-1)*2+2),'oc');
    end
end