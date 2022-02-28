function alignedI1 = alignImage(I1,I2,H)
% This function aligns image 1 to image 2 using the estimated homography

% inputs:
% I1: input image 1 (image to be transformed and aligned)
% I2: input image 2 (reference image)
% H: homography matrix which describes affine transformation from I1 to I2

% Make sure image in double
I1 = im2double(I1);
I2 = im2double(I2);

% aligned image I1 to image I2 using the homography matrix H
[height,width,~] = size(I2);
[alignedI1, rb] = imwarp(I1,H);

% trim the image so that it lies in frame of image 2
if size(alignedI1,1) < height
    alignedI1 = cat(1,alignedI1,zeros(height-size(alignedI1,1),size(alignedI1,2),size(alignedI1,3)));
end
if size(alignedI1,2) < width
    alignedI1 = cat(2,alignedI1,zeros(size(alignedI1,1),width-size(alignedI1,2),size(alignedI1,3)));
end
alignedI1=imtranslate(alignedI1,[rb.XWorldLimits(1),rb.YWorldLimits(1)],'nearest');
if height < size(alignedI1,1)
    endx = height;
else
    endx = size(alignedI1,1);
end
if width < size(alignedI1,2)
    endy = width;
else
    endy = size(alignedI1,2);
end
temp = double(zeros(size(I2)));
temp(1:endx,1:endy,:) = alignedI1(1:endx,1:endy,:);
alignedI1 = temp;
end

