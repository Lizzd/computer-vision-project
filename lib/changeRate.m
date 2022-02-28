function changeRate = changeRate(changeMap)
% calculate the change rate with respect to the last image
%
% Input:
% changeMap            black/white change map with respect to the last image
%
% Output
% changeRate           change rate
numChange = sum(changeMap,'all');
changeRate = numChange/numel(changeMap)*100;
end