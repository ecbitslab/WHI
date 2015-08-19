function [cp]=peaks2centroids(h,cp)

%% Summary of function peaks2centroids.m
% Use the centroid locating tools in the MATLAB image analysis toolbox to
% pull the mouse click to the centroid of a putative marker

% INPUT:
% - h: Axis object handle.
% - cp: Initial guess of coordinate points.

% OUTPUT:
% - cp: Final calculated centroid coordinate points.

% Original method click2centroid.m written by Hedrick Lab at UNC Chapel Hill, 
% http://www.unc.edu/~thedrick/software1.html (begins on line 1102 of
% DLTcal5 code).

% Modified to peaks2centroids.m by Michael Meaden, Elmhurst College BITS
% Lab, June 30, 2014.
% - Added loop to calculate array of centroids from array of intensity
%   peaks for a certain area of an image (handles multiple centroids at
%   once).

%% Begin main code block.
psize=round(str2double(get(h(59),'String'))); % search area size

% set more variables within the loop
kids=get(h(40),'Children'); % children of current axis
imdat=get(kids(end),'CData'); % read current image
x=round(cp(1,1)); % get an integer X point
y=round(cp(1,2)); % get an integer Y point

% copy imdat, apply gamma to imdat & rescale
imdat=double(imdat(:,:,1)); % convert from uint8 to double

% determine the base area around the mouse click to
% grab for centroid finding
try
  roi=imdat(y-psize:y+psize,x-psize:x+psize);
catch
  return
end

% apply gamma and rescale
roi=roi.^get(h(13),'Value');
roi=roi-min(min(roi));
roi=roi*(1/max(max(roi)));

% detrend the roibase to try and remove any image-wide edges
roibase=rot90(detrend(rot90(detrend(roi))),-1);

% rescale roibase again following the detrend
roibase=roibase-min(min(roibase));
roibase=roibase*(1/max(max(roibase)));

% threshhold for conversion to binary image
level=graythresh(roibase);

% convert to binary image
roiB=im2bw(roibase,level+(1-level)*0.5);

% create alternative, inverted binary image
roiBi=im2bw(roibase,level/1.5);
roiBi=logical(roiBi*-1+1);

% identify objects
[labeled_roiB]=bwlabel(roiB,4);
[labeled_roiBi]=bwlabel(roiBi,4);

% get object info
roiB_data=regionprops(labeled_roiB,'basic');
roiBi_data=regionprops(labeled_roiBi,'basic');

% for each roi*_data, find the largest object
roiB_sz=zeros(length(roiB_data),1);
for i=1:length(roiB_data)
  roiB_sz(i)=roiB_data(i).Area;
end
roiB_dx=find(roiB_sz==max(roiB_sz));

roiBi_sz=zeros(length(roiBi_data),1);
for i=1:length(roiBi_data)
  roiBi_sz(i)=roiBi_data(i).Area;
end
roiBi_dx=find(roiBi_sz==max(roiBi_sz));

% check "white" or "black" option from menu
% 1 == black, 2 == white
whiteBlack=get(h(57),'Value');
if whiteBlack==1
  % black points
  % create weighted centroid from bounding box
  bb=roiBi_data(roiBi_dx(1)).BoundingBox;
  bb(1:2)=ceil(bb(1:2));
  bb(3:4)=(bb(3:4)-1)+bb(1:2);
  blk=1-roibase(bb(2):bb(4),bb(1):bb(3));
else
  % white points
  % create weighted centroid from bounding box
  bb=roiB_data(roiB_dx(1)).BoundingBox;
  bb(1:2)=ceil(bb(1:2));
  bb(3:4)=(bb(3:4)-1)+bb(1:2);
  blk=roibase(bb(2):bb(4),bb(1):bb(3));
end
ySeq=(bb(2):bb(4))';
yWeight=sum(blk,2);
cY=sum(ySeq.*yWeight)/sum(yWeight);
xSeq=(bb(1):bb(3));
xWeight=sum(blk,1);
cX=sum(xSeq.*xWeight)/sum(xWeight);
cp(1,1)=x+cX-psize-1;
cp(1,2)=y+cY-psize-1;
