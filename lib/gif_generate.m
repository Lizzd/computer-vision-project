function gif_generate(nColors,index,speed, overlap_cell,diff_cell, mask_cell,image_loc_2,runtime)
%% This function generates GIF based on changeMap with or without segmentation effect with help of prepared data
%Inputs:
%nColors         number of colors(clusters)
%index           the index of the segment you want to derive
%diff_cell :     cell stores all changeMap between each image and reference
%images
%overlap_cell:   cell stores all combined images in which overlapped part of
%current image and reference image is from current image and the rest part
%is from reference image
%mask_cell:      cell stores mask, to record the area that in each combined
%image but originally belonges reference image
%image_loc_2:    the index of last image you want see,default 10
%runtime:        speed of changes shown in GIF
%% 
image_loc_1 = 3;
img = cell2mat(overlap_cell(1));

if nColors == 1 || index == 0
    ifseg = 0;
else
    ifseg = 1;
end


if ifseg == 1
[~,Im_highlight,~,~] = ColorSegKMeansCluster(im2uint8(img), nColors);
img = im2double(Im_highlight{1});
end

filename = ['GIF/' num2str(runtime)  '.gif'];
for j = 1:speed:image_loc_2-image_loc_1
    if j == image_loc_2-image_loc_1 && speed ==2
        Image_new = cell2mat(overlap_cell(j+1));
        dif = cell2mat(diff_cell(j-1));
    else
        Image_new = cell2mat(overlap_cell(j+speed));
        dif = cell2mat(diff_cell(j));
    end
    if ifseg == 1
        [Im_highlight,~,~,~] = changeMapSeg(im2uint8(Image_new),im2uint8(dif),nColors,im2uint8(Image_new),index);
        Image_new = im2double(Im_highlight);
    end
   dif = repmat(dif, [1 1 3]);
   for n = 1:1:10
      img(dif==1) = (Image_new(dif==1) - img(dif==1))./10.* n + img(dif==1);
      [imind,cm] = rgb2ind(img,256); 
      % Write to the GIF File 
      if n == 1 && j ==1
         imwrite(imind,cm,filename,'gif', 'Loopcount',inf); 
      else 
         imwrite(imind,cm,filename,'gif','WriteMode','append', 'DelayTime',0.1); 
      end 
   end
end    

end

