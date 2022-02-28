function [Imhighlight, pixel_labels] = SegHighlight(I, nColors)
% This function implements the color based k mean clustering of an image
%
% Inputs:
% I               input image(RBG)
% nColors         number of colors(clusters)
% 
% Outputs:
% Imhighlight     segmented images with highlight stored in a cell
% pixel_labels    label of the clusters (label of each pixel in an image )

% color based k mean clustering
[~, pixel_labels] = ColorSegKMeansCluster(I, nColors);    

% store each cluster with highlight in a cell
Imhighlight = cell(1,nColors);
for i=1:nColors
    mask = pixel_labels==i;
    Inew = im2uint8(I).*uint8(mask);
    I1 = I;
    I1 = I1*0.5;
    I1(pixel_labels==i) = Inew(pixel_labels==i);
    Imhighlight{i} = I1;
end
end 