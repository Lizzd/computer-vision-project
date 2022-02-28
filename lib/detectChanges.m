function diff = detectChanges(alignedI1,I2)
% This function compute the difference map of the two input images

% Inputs
% alignedI1: Image 1 which is aligned with image 2
% I2 : image 2 (reference image)

% Ouput
% diff: difference map 

% compute difference map
diff =(I2-alignedI1).^2;
diff(alignedI1==0) = 0; % set non overlap part as zero
end

