function gif_generate_dummy(speed,nColors,index,overlap_cell,mask_cell,image_loc_2,runtime)
%% This function generates GIF with or without segmentation effect with help of prepared data
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
%runtime: speed of changes shown in GIF

%% 
img = cell2mat(overlap_cell(1));
image_loc_1 = 3;
refrence_index = round((image_loc_2-image_loc_1)/2)+image_loc_1;
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
        dif_mask = cell2mat(mask_cell(j)).* cell2mat(mask_cell(j+1));
    else
        img = cell2mat(overlap_cell(j));
        Image_new = cell2mat(overlap_cell(j+speed));
        if j <= refrence_index-image_loc_1+1
            dif_mask = cell2mat(mask_cell(j)).* cell2mat(mask_cell(j+speed));
        else
            dif_mask = cell2mat(mask_cell(j)).* cell2mat(mask_cell(j-speed));
        end
    end
    if ifseg == 1
        [~,Im_highlight,~,~] = changeMapSeg(im2uint8(img),0,nColors,im2uint8(img),index);
        img = im2double(Im_highlight);
        [Im_highlight, ~,~,~] = changeMapSeg(im2uint8(Image_new),0,nColors,im2uint8(Image_new),index);
        Image_new = im2double(Im_highlight);
    end
   dif_mask = repmat(dif_mask, [1 1 3]);
   
   for n = 1:1:10
      img(dif_mask==1) = (Image_new(dif_mask==1) - img(dif_mask==1))./10.* n + img(dif_mask==1);
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

