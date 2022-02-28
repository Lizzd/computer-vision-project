function [Im_cell,Im_highlight,pixel_labels,Im2_cell] = ColorSegKMeansCluster(I, nColors, alignedI2)    
% This function implements the color based k mean clustering of an image
% and store each cluster image into a cell.
%
% Inputs:
% I               input image(RGB)
% alignedI2       aligned image2 (RGB)
% nColors         number of colors(clusters)
% 
% Outputs:
% Im_cell         segmented images of I1 stored in a cell
% Im_highlight    highlighted segmented images stored in a cell
% pixel_labels    label of the clusters (label of each pixel in an image )
% Im2_cell        segmented alignedI2 image with highlight applying the cluster mask of I1

% color based k mean clustering
lab_I = rgb2lab(I);
ab = lab_I(:,:,2:3);
ab = im2single(ab);
[pixel_labels,centers] = imsegkmeans(ab,nColors,'NumAttempts',3);

% relabel the clusters to avoid random label number of each cluster
[~,index] = sortrows(centers);
sz_index = size(index);
for i=1:sz_index
    pixel_labels(pixel_labels==index(i)) = i+10;
end
pixel_labels = pixel_labels-10;        

% store each cluster image into a cell
Im_cell = cell(1,nColors);
Im2_cell = cell(1,nColors);
Im_highlight = cell(1,nColors);
for i=1:nColors
    % store each cluster in a cell
    mask = pixel_labels==i;
    cluster = I.*uint8(mask);
    Im_cell(i) = {cluster};

    % store each highlighted cluster on the original image in a cell
    mask1 = im2double(mask);
    mask1(mask1==0) = 0.5;
    cluster_highlight = im2double(I).*mask1;
    cluster_highlight = im2uint8(cluster_highlight);
    Im_highlight(i) = {cluster_highlight};
    if exist('alignedI2','var')
        Im2_cluster = im2double(alignedI2).*mask1;
        Im2_cluster = im2uint8(Im2_cluster);
        Im2_cell(i) = {Im2_cluster};
    end
end
end
