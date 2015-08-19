function out = orderArrayCoords(coords, ppr, ppc)

%% Summary of function orderArrayCoords:

% Given a set of two dimensional pixel coordinates corresponding to a
% well-ordered two dimensional square array of dots (from an image),
% organizes the data so that the first set of coordinates to appear in the
% list corresponds to the bottom left corner of the array.  The subsequent
% entries correspond to the coordinates for the bottom row of points in the
% array before moving on to the next row up and so on.

% INPUT:
% coords: Matrix of unsorted xy pixel coordinates corresponding to the
%         dots in the array shown in the image.
%
% ppr:    An integer value giving the points per row in the array of points
%         in the image.  This makes processing much easier.
%
% ppc:    An integer value giving the points per column in the array of
%         points in the image.  Allowing this to be different than ppr
%         allows for the possibility of handling non-square arrays.
%
% OUTPUT:
% out: Matrix of sorted xy pixel coordinates corresponding to the dots in
%      the array shown in the image.
%
% Written by Michael Meaden, Elmhurst College BITS Lab, 4/23/2014

%% Main Code Block

% Sort in descending order according to the y values.  Since dealing with
% pixel coordinates, the larger y value will be at the bottom of the image,
% and so should be at the top of the list.
out = sortrows(coords,-2);

% Next, sort each row in the array in ascending order according to the x
% values.
for ii = 1:1:ppc
    out((ii-1)*ppr+1:(ii*ppr),:) = sortrows(out((ii-1)*ppr+1:(ii*ppr),:),1);
end
