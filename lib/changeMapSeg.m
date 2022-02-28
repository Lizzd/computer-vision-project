function [Im_highlight,Im_changeMapSeg,changeRateSeg,Im2_cell] = changeMapSeg(I,changeMap,nColors,alignedI2,index)
% This function gives the segmentation of the change and changing rate in
% each cluster
%
% Inputs:
% I                reference image (rgb unit8)
% changeMap        detected changes (unit8 output of function pcaKmeans.m)
% nColors          number of clusters
%
% Output:
% Im_changeMapSeg  segmentation of detected changes annotated in the original image stored in a cell
% Im_highlight     highlighted segmented images stored in a cell
% changeRateSeg    changing rate of each segments with respect to the reference segmentation
% Im2_cell         segmented alignedI2 image with highlight applying the cluster mask of I1
% index            the index of the segment you want to derive

[~,Im_highlight,pixel_labels,Im2_cell] = ColorSegKMeansCluster(I, nColors, alignedI2);
Im_changeMapSeg = cell(1,nColors);
changeRateSeg = [];
for i=1:nColors
    mask = pixel_labels==i;
    changeMapi = changeMap.*uint8(mask);
    Im_colored = colorPixel(changeMapi,changeMapi);
    Im_highlight_cluster = Im_highlight{i};
    temp = Im_colored(:,:,1);
    temp = cat(3,zeros(size(temp)),temp,temp);
    Im_highlight_cluster(Im_colored~=0) = Im_colored(Im_colored~=0);
    Im_highlight_cluster(temp~=0) = 0;
    Im_changeMapSeg(i) = {Im_highlight_cluster};
        
    
    % calculate change rate
    mask_pixels = sum(sum(mask==1));
    change_pixels = sum(sum(changeMapi==255));
    change_rate = change_pixels/mask_pixels;
    changeRateSeg = [changeRateSeg change_rate];
end
if exist('index','var')
    Im_highlight = Im_highlight{index};
    Im_changeMapSeg = Im_changeMapSeg{index};
    Im2_cell = Im2_cell{index};
end
end
