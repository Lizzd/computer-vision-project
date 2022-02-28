function data = init(image_loc)
% This function initialzes the estimation of homographies of all images in
% the input folder.

% input: 
% image_loc: folder location which contains the images
% output: data structure contains 
%         data.H: homography matrix of consecutive images
%         data.Image: input images
%         data.time: time at which the image is taken (name of the image)

    % read images from given file directory
    addpath(image_loc);
    folder_dir = dir(image_loc);

    % process all the images in the folder
    for i = 3:length(folder_dir)-1
        rgb1 = imread(folder_dir(i+1).name); 
        rgb2 = imread(folder_dir(i).name);
        % crop out the 'Google' logo to avoid getting wrong correspondence points
        rgb1 = imcrop(rgb1,[1 1 size(rgb1,2) 1000]);
        rgb2 = imcrop(rgb2,[1 1 size(rgb2,2) 1000]);
        I2 = im2double(rgb2gray(rgb2));
        I1 = im2double(rgb2gray(rgb1));
        % Normalization 
        I1 = (I1-mean(I1,'all'))/std(I1(:));
        I2 = (I2-mean(I2,'all'))/std(I2(:));

        % Detect and match features
        [features1,valid_points1] = detectFeature(I1,5000);
        [features2,valid_points2] = detectFeature(I2,5000);
        
        % Find geometric transformation
        [~, H] = ref_featuresMatching(features1,valid_points1,features2,valid_points2);
        
        % Store data
        data.H{i-2} = H;
        if i == 3 
            data.Image{1} = rgb2;
            data.time{1} = folder_dir(3).name;
            data.Image{2} = rgb1;
            data.time{2} = folder_dir(4).name;
            disp('Pre-processing images');
        else
            data.Image{i-1} = rgb1;
            data.time{i-1} = folder_dir(i+1).name;
        end
        fprintf('Iteration : %d/%d\n',i-2,length(folder_dir)-3);
    end
end
