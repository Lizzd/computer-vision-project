function [features,validpoints] = detectFeature(image,noFeatures)
% This functions detects the input image's features using KAZE detector

% Input
% image : input image
% noFeatures: number of features to be returned

% Output
% features,validpoints

if ~exist('noFeatures','var')
    noFeatures = 20000;
end
% detect features of the image
points = detectKAZEFeatures(image);
points = points.selectStrongest(noFeatures);
[features,validpoints] = extractFeatures(image,points);
end

