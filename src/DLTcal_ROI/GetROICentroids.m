function [out, th, sz] = GetROICentroids(im,th,sz,ppim)

%% Summary of function GetROICentroids
% Locates all centroids within a region of interest.  Used in a DLT
% Calibration procedure using a well ordered array or precisely engineered
% points.  This script allows for quick extraction of the image pixel
% coordinates that correspond to 3D world coordinates (imported from excel
% file).

% INPUT:
% im:  RGB image file name and extension. Note that the image is read within
%      this function.  An image matrix should not be given as input.
%
% th:  Used when calling the function pkfnd.  The minimum brightness of a
%      pixel that might be local maxima.
%      (NOTE: Make it big and the code runs faster but you might miss some
%      particles.  Make it small and you'll get everything and it'll be slow.)
%
% sz:  Used when calling the function pkfnd.  If your data's noisy,
%      (e.g. a single particle has multiple local
%      maxima), then set this optional keyword to a value slightly larger 
%      than the diameter of your blob.  If multiple peaks are found within
%      a radius of sz/2 then the code will keep only the brightest.  Also
%      gets rid of all peaks within sz of boundary.
%
% ppim:  Expected number of points per image.  Used when automatically
%        removing spurious points and also during coordinate sorting.

% OUTPUT:
% out:  The 2D pixel coordinates of the centroids in the image.
%             Calculated to subpixel accuracy.
%
% th:   Returns the th value used.  This is important if the user changes
%       the th value so they don't have to change it for each frame.
%
% sz:   Returns the sz value used.  This is important if the user changes
%       the sz value so they don't have to change it for each frame.

% Initially written by Venkatesh Gopal, Elmhurst College BITS Lab,
% 3/27/2014.

% Modified by Michael Meaden, Elmhurst College BITS Lab, 4/22/2014.
% - Modified the code to be a function that could easily be integrated with
%   the script DLTcal_ROI.m

%% Main Code Block

close all;

% Tell user which image is currently being displayed.
fprintf('\n');
disp(['Image file ', im, ' currently displayed.']);

% Load RGB image, invert, and convert to grayscale
a = rgb2gray(imread(im));
a = 255 - a;
imagesc(a); colormap(gray)

% Select region of interest
vertices = round(getrect);
subimg = a(vertices(2): vertices(2)+vertices(4),vertices(1):vertices(1)+vertices(3));

% Select peaks using pkfnd
% These are the parameter values that did not pick up spurious points
mx = pkfnd(subimg,th,sz);

% Use the output of pkfnd as an input for the cntrd function to locate all
% centroids in the subimage.
% Adjust size for cntrd function.
sz2 = 9;
sub_coords = cntrd(subimg,mx,sz2);

% Plot the centroids returned by cntrd on the subimg.  This output allows
% the user to judge whether they are happy with the output or not.
figure; imagesc(subimg);colormap(gray); hold on;
plot(sub_coords(:,1),sub_coords(:,2),'rx');

% Display the number of centroids found in the current image.
disp([num2str(size(sub_coords,1)), ' points found in the current image.']);

% Ask user if they are satisfied with their product.
flag = 1;
while(flag == 1)
    reply = input('Are you satisfied with the output coordinates? Y/N (No Input = Y): ', 's');
    
    % If the user is satisfied with the output, skip to the sort step.
    if (strcmpi(reply,'y') || strcmpi(reply,'yes') || isempty(reply))
        flag = 0;
        
    % If the user is NOT satisfied, then ask if they want to modify the
    % parameters (if they just misclicked, then they might not need to).
    % Regardless, rerun this function with the specified parameters.
    else if strcmpi(reply,'n') || strcmpi(reply,'no')
            reply = input('Do you want to change the parameters th and sz? Y/N (No Input = N): ','s');
            if (strcmpi(reply,'y') || strcmpi(reply,'yes'))
                disp(['The current threshold value th is ', num2str(th), '.']);
                th_temp = input('Enter the new threshold value, th.  This value is the minimum brightness \n of a pixel that might be considered a local maximum. \n (No Input keeps the same th value): ');
                if (~isempty(th_temp))
                    th = th_temp;
                end
                disp(['The current size value sz is ', num2str(sz), '.']);
                sz_temp = input('Enter the new size value, sz.  This value should be slightly larger than the \n diameter of the "blobs" for which the centroids are being found (in pixels). \n (No Input keeps the same sz value): ');
                if (~isempty(sz_temp))
                    sz = sz_temp;
                end
            end
            
            % Re-run the centroid finder with the new (or same parameters).
            out = GetROICentroids(im,th,sz,ppim);
            return;
            
        % If the user gave invalid input, ask if they are satisfied again.
        else
            disp('Invalid Input')
            flag = 1;
        end
    end
end

% Transform the coordinates that were returned from cntrd back to the full
% image coordinates.  This is necessary since the pixel coordinates
% returned above were found from the subimage.
full_coords(:,1) = sub_coords(:,1) + vertices(1);
full_coords(:,2) = sub_coords(:,2) + vertices(2);

% Plot the corresponding coordinates for the full image.
figure; imagesc(a); colormap(gray); hold on;
plot(full_coords(:,1),full_coords(:,2),'rx');

% Once the user is satisfied with the centroid coordinates found for this
% image, sort the coordinates.
out = orderArrayCoords(full_coords,sqrt(ppim),sqrt(ppim));

% Modify the y coordinates in the im_coords matrix so that smaller y values
% are at the bottom of the image.
imy_max = size(a,1);
out(:,2) = imy_max - out(:,2);



