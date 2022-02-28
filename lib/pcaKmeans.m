function changeMap = pcaKmeans(diff,h,S)
% This function takes the difference map and classified each pixel to
% unchanged and changed region, with label 0 and 1 respectively.

% Input
% diff: difference map
% h: blocks size
% S: dimension of feature vector

% Output
% changeMap : change map

% reference:
%Celik, Turgay. "Unsupervised change detection in satellite images using principal component analysis and $ k $-means clustering." IEEE Geoscience and Remote Sensing Letters 6.4 (2009): 772-776.

%%Partitioning difference map into hxh non-overlapping blocks
if ~exist('h','var')
    h = 4;
end
if ~exist('S','var')
    S = 3;
end
[height,width] = size(diff);
% M = floor(height*width/h/h);
%% Padding h zeros around difference map
padding_size = size(diff) + h;
padding_img = zeros(padding_size);
lb = ceil(h/2);
ub_col = lb+height-1;
ub_row = lb+width-1;
padding_img(lb:ub_col,lb:ub_row)=diff;

%% Store element of each blocks as column vector in a matrix
xd = zeros(h*h,height*width);
k = 1;
for i = 1:height
    for j = 1:width
        temp = padding_img(i:i+h-1,j:j+h-1);
        xd(:,k)=temp(:);
        k = k+1;
    end
end

%% PCA and K-means clustering
mean_vec = mean(xd,2);
delta_xd = (xd-repmat(mean_vec,[1,size(xd,2)]));
[EigVec,~,~] = pca(delta_xd','NumComponents',S);
V = delta_xd'*EigVec;
label = kmeans(V,2)-1;


%% return the cluster map
changeMap = reshape(label,[width,height]);
changeMap = changeMap';

% make sure area of changes has label of 1
idx = find(diff == 0);
if sum(changeMap(idx)==0) < length(idx)/2
    changeMap = 1-changeMap;
end
end