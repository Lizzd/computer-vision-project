function changeBlockSize = largeLittleChange(changeMap)
%This function groups changed region in change map in to large and little
%region of changes with label 2 and 1 respectively. Label for unchanged
%pixels remains 0.

% Input
% change map: change map consists of 0 (no change) and 1 (change region)

% Output
% changeBlockSize : change map with unchanged, large and little change
% label
    cc = bwconncomp(changeMap,8);
    for i = 1:cc.NumObjects
        objectSize(i) = length(cc.PixelIdxList{i});
    end
    largeIdx = find(objectSize > 100);
    lilIdx = find(objectSize<=100);
    
    changeBlockSize = zeros(size(changeMap));
    
    for i = 1:max(length(lilIdx),length(largeIdx))
        if i<= length(lilIdx)
            idx = cc.PixelIdxList{lilIdx(i)};   
            changeBlockSize(idx) = 1;
        end
        
        if i<= length(largeIdx)
            idx = cc.PixelIdxList{largeIdx(i)};
            changeBlockSize(idx) = 2;
        end
    end
end
