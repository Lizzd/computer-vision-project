function Im_colored = colorPixel(I,mask)
% color the pixels to red according to a given mask (locations where mask does not equal 0)
%
% Inputs:
% I              given image (here changeMapi)
% mask           gives the location of pixels to be colored
%
% Output
% Im_colored     colored image 

[x,y,~]=size(I);
for ii=1:x
    for jj=1:y
        if mask(ii,jj)~=0
            I(ii,jj,1) = 255;I(ii,jj,2) = 0;I(ii,jj,3) = 0;
            
        end
    end
end
Im_colored = I;
end