function [overlap_cell,mask_cell] = gif_prepare_dummy(data,image_loc,mode)
%% This function prepares combined images between each image and reference image
%for generation of GIF based on changeMap.
%Inputs:
%data:          structure object contains all homography matrices of every two
%adjacent images
%image_loc:     path of image folder
%Outputs:
%overlap_cell:  cell stores all combined images in which overlapped part of
%current image and reference image is from current image and the rest part
%is from reference image
%mask_cell:     cell stores mask, to record the area that in each combined
%image but originally belonges reference image

%% data prepare
%speed = 1;
if ~exist('mode','var')
    speed = 1;
elseif strcmp(mode,'Fast')
    speed = 2;
else
    speed = 1;
end
addpath(image_loc);
folder_dir = dir(image_loc);
image_loc_1 = 3;
image_loc_2 = size(folder_dir,1);
refrence_index = round((image_loc_2-image_loc_1)/2)+image_loc_1;
rgb_reference_ori = im2double(imread(folder_dir(refrence_index).name));%old
rgb_reference = imcrop(rgb_reference_ori,[1 1 size(rgb_reference_ori,2) 1000]);

%% directly get all Hs with the reference image
rgb1_cell = cell(1, image_loc_2-image_loc_1+1);
for i = refrence_index-1:-1:image_loc_1
   rgb1 = im2double(imread(folder_dir(i).name)); %new
   rgb1 = imcrop(rgb1,[1 1 size(rgb1,2) 1000]);
   rgb1_cell(i - image_loc_1+1) = {rgb1};
    if abs(i -refrence_index)==1
        tem = data.H{i-3+1}.T;
        tem = inv(tem);
        tem(:,3) = [0,0,1]';
        H_array(1, i - image_loc_1+1) = projective2d(tem);

    else
        tem = data.H{i-3+1}.T;
        tem = inv(tem);
        tem(:,3) = [0,0,1]';
        H_array(1, i - image_loc_1+1) = projective2d(tem*H_array(1, i - image_loc_1+1+1).T);

    end
    
end
for i = refrence_index:1:image_loc_2
   if i ==  refrence_index
       rgb1_cell(i - image_loc_1+1) = {rgb_reference};
       H = double(eye(3));
       H = projective2d(H);
       H_array(1, i - image_loc_1+1) = H;
   else
   rgb1 = im2double(imread(folder_dir(i).name)); %new
   rgb1 = imcrop(rgb1,[1 1 size(rgb1,2) 1000]);
   rgb1_cell(i - image_loc_1+1) = {rgb1};

    if abs(i -refrence_index)==1
        H_array(1, i - image_loc_1+1) = projective2d(data.H{i-3}.T);
    else
        tem = data.H{i-3}.T;
        H_array(1, i - image_loc_1+1) = projective2d(tem*H_array(1, i - image_loc_1+1-1).T);

    end
    end
    
end

    
%% combied image (all with the reference)
overlap_cell = cell(1, image_loc_2-image_loc_1+1);
mask_cell = cell(1, image_loc_2-image_loc_1+1);

for  i = 1:speed:image_loc_2-image_loc_1+1%speed = 2
   if i == refrence_index-image_loc_1+1
       overlap_cell(i) = rgb1_cell(i);
       mask_cell(i) = {ones(size(cell2mat(rgb1_cell(i)), 1),size(cell2mat(rgb1_cell(i)), 2))};
       rgb_reference_new = rgb1_cell{i};
   else
       H = H_array(1, i);
       alignedI1 = alignImage(cell2mat(rgb1_cell(i)),rgb_reference,H);
       if i ==1
            nonOverlap = alignImage(ones(size(alignedI1)),rgb_reference,H);
            rgb_reference_new = rgb_reference;
            rgb_reference_new(nonOverlap==0) = 0;
       end
       [overlap, mask] = combine_new(rgb_reference_new,alignedI1);  
       overlap_cell(i) = {overlap};
       mask_cell(i) = {mask};
       rgb_reference_new = overlap;
   end
end
if i == image_loc_2-image_loc_1 && speed == 2
    H = H_array(1, i+1);
    alignedI1 = alignImage(cell2mat(rgb1_cell(i+1)),rgb_reference,H);
    [overlap, mask] = combine_new(rgb_reference,alignedI1);
    overlap_cell(i+1) = {overlap};
    mask_cell(i+1) = {mask};
end
end

