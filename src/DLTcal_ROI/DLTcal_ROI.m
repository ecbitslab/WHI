function [im_coords, C, rmse] = DLTcal_ROI(world_coords,th,sz)

%% Summary of function DLTcal_ROI.m

% Function to calibrate a camera using the DLT algorithm.  Uses a
% region of interest centroid finder to calculate the centroids in a well
% ordered array of points that is very precisely engineered.  These
% centroids are the image coordinates to be used in the DLT calibration.

% INPUT:
% - world_coords:  Matrix specifying the world coordinates used in the DLT
%                  calibration.
%
% - th: Threshold pixel intensity used in the large scale centroid finder.
%
% - sz: Approximate diameter of a "blob" in the images. Used in the large
%       scale centroid finder.
%
% OUTPUT:
% - im_coords:  The 2D image coordinates corresponding to the 3D world
%               coordinates. Found using a large scale centroid finder.
%
% - C:  Matrix containing the camera coefficients obtained by running the
%       DLT calibration.
%
% - rmse:  The root mean square residual error found by analyzing the
%          reprojection error after the calibration is completed.

% Written by Michael Meaden, Elmhurst College BITS Lab, 4/16/2014.

% DLT calibration script courtesy of the Hedrick Lab,
% http://www.unc.edu/~thedrick/software1.html.

% DLTcal_ROI written by Michael Meaden, Elmhurst College BITS Lab, 4/9/2014

%% Select image files to be used for calibration.

% Prompt the user to select the calibration image files.
disp('Select the calibration image files. (Ctrl-click to pick several)');
pause(0.1);

% Prompt user to select images to be used for calibrating this camera.
[imnames,im.impname]=uigetfile( {'*.bmp;*.tif;*.jpg;*.avi;*.cin', ...
  'Image files (*.bmp, *.tif, *.jpg, *.avi, *.cin)'}, ...
  ['Select the calibration image files. (Ctrl-click to pick',...
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

% Assume the same pattern is used in each image and therefore that the
% total number of points is split evenly between the number of images.
npts = size(world_coords,1);
ppim = npts/nim;

% Tell user how many points per image they should expect to find.
disp(['Each image is expected to have ', num2str(ppim), ' points specified.']);

%% Locate centroids in each image.

% Initialize cpim (coordinates per image) matrix. This matrix will hold the
% centroid coordinates found for each image and will be restructured later
% to a format that matches the world coordinate specification file.
cpim = zeros(ppim,2,nim);

% For each image, call function getROIcentroids.  This prompts the user to
% select the region of interest where the centroids need to be found.
for ii = 1:1:nim
    % Get image path and name.
    imfile = strcat(im.impname,im.imfname{ii});
    [cpim(:,:,ii), th, sz] = GetROICentroids(imfile,th,sz,ppim);
end

% Restructure cpim matrix so that it is compatible with
% dlt_computeCoefficients.  Assumes the points in each image are sorted
% properly and that the images are in the correct order (i.e. points 1
% through ppim are in image one, points ppim+1 through 2ppim are in image
% 2, etc. as defined by the world coordinate specification file).
for ii = 1:1:nim
    im_coords((ii-1)*ppim+1:ii*ppim,:) = cpim(:,:,ii);
end

%% Calibrate camera using DLT algorithm with im_coords and X, Y, Z.
[C, rmse] = dlt_computeCoefficients(world_coords,im_coords(:,:));



