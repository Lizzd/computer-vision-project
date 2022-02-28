function [overlap, mask_i] = combine_new(I2,alignedI1)
%% This function combines current image and reference image 
% Input:
%I2 :       reference image
%alignedI1: rotated image
%overlap:   combined image, overlap part from current rotated image, the rest
%part from reference image
mask =alignedI1(:,:,1)==0& alignedI1(:,:,2)==0&alignedI1(:,:,3)==0;
I2_masked = I2.*mask;
overlap = I2_masked + alignedI1;
mask_i = zeros(size(mask));
mask_i(mask==0) = 1;
end
