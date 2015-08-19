%% Script genMovie.m

% Generates an avi file from a series of images.  This is intended for use
% with the Hedrick DLTdv5 GUI.

% Written by Michael Meaden, Elmhurst College BITS Lab, 5/27/2014.

%% Main Code Block

% Reinitialize workspace.
close all; clear all; clc;

% Prompt the user to select the image files.
disp('Select the image files to be used in the video. (Ctrl-click to pick several)');
pause(0.1);

% Prompt user to select images to be used when generating video.
[imnames,im.impname]=uigetfile( {'*.bmp;*.tif;*.jpg;*.avi;*.cin', ...
  'Image files (*.bmp, *.tif, *.jpg, *.avi, *.cin)'}, ...
  ['Select the image files to be used in the video. (Ctrl-click to pick',...
  ' several)'],'MultiSelect','on');
if iscell(imnames)==0 % convert strings to cells
  im.imfname={imnames};
else
  for ii=2:numel(imnames)
    im.imfname{ii-1}=imnames{ii};
    im.imfname{end+1}=imnames{1};
  end
end

% Sort the image file names
im.imfname=sort(im.imfname);

% Get the number of images used.
nim = size(im.imfname,2);

% Create VideoWriter object.
vidOut = VideoWriter('dot_exp_right.avi');
open(vidOut);

% Generate .avi file from images.
for ii = 1:1:nim
    imfilename = strcat(im.impname,im.imfname{ii});
    img = imread(imfilename);
    writeVideo(vidOut,img);
end

close(vidOut);

implay('dot_exp_right.avi');