function [correspondences_robust,H] = ref_featuresMatching(features1,valid_points1,features2,valid_points2)
% This function matches the input features and return the robust
% correpondence point pairs and the estimated homography

% Input
% features1,valid_points1: feature points and valid points of image 1
% features2,valid_points2: feature points and valid points of image 2

% Output
% correspondences_robust: robust correspondence point pairs 
% H: estimated affine homography matrix

% find H using matlab built in function
indexPairs = matchFeatures(features1,features2,'MaxRatio' ,0.5,'Unique',true,'MatchThreshold',10);
matchedPoints1 = valid_points1(indexPairs(:,1),:);
matchedPoints2 = valid_points2(indexPairs(:,2),:);
[H,inlierIdx] = estimateGeometricTransform2D(matchedPoints1,matchedPoints2,'affine');
correspondences_robust = [matchedPoints1(inlierIdx,:).Location';matchedPoints2(inlierIdx,:).Location'];

if size(correspondences_robust,2) < 10
    warning('too little correspondence point pairs!');
end
if size(correspondences_robust,2) > 2000
    correspondences_robust = correspondences_robust(:,1:2000); % avoid too many point pairs in case of same image
end