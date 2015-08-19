function genOSF(n,d)

%% Summary of function genOSF
% Script to generate an object specification file for DLT calibration
% method using the well-ordered array of dots (26x26 array of 1 mm spaced
% dots). The array is assumed to be translated only in the z direction
% between images, and the distance the array is translated between
% consecutive images is assumed to be the same between each consecutive
% pair of images.

% INPUT
% - n: Number of frames to be used in calibration.
% - d: Distance array is moved along z axis between consecutive images.

% OUTPUT
% 3D coordinates of dots are saved in a .csv file with headers x, y, and z.

% Written by Michael Meaden, Elmhurst College BITS Lab, 5/22/2014.

%% Main Code Block.

