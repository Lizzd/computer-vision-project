function diffHighlightMap = diffHighlightVis(rgb2,changeMap,large_change)
% This functions highlight region of changes in red color

% Input
% rbg2 : color image 2
% changeMap: change map 

% Output
% diffHighlightMap: difference highlight map

% Generate difference highlight map with area of changes in red 
if large_change == 1
    changeMap(changeMap(:)==1) = 0;
    changeMap(changeMap(:)==2) = 1;
elseif large_change == 0
    changeMap(changeMap(:)==2) = 0;
else 
    changeMap(changeMap(:)==2) = 1;
end
diffHighlightMap = labeloverlay(rgb2,changeMap,'Colormap',[1 0 0;1 1 1]);
end