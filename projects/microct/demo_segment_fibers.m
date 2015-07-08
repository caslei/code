
clear all;
close all;

% read full image, select 1 slice for training
disp('reading 3D image data ...')
img_3D = imread3D('/net/ipi/scratch/jbroels/microct/reconstructed2/stack.tif');

segment_3D = 0; % set to 1 if you want to segment full 3D dataset, 0 for a single slice
slice_num = 200;

% load im.mat
if ~segment_3D
    img = squeeze(img_3D(slice_num,:,:));
    clear img_3D;
else
    img = img_3D;
    clear img_3D;
end

% extract top and bottom background and set this to 0
T = 4000;
bg = imerode(imclose(img<T,strel('disk',3)),strel('disk',7));
img(bg) = 0;

% filters that will be used for feature extraction
filter_l = fspecial('average');
filter_h = fspecial('prewitt');
filter_v = filter_h';

% slice features
n_features = 5;
feature_names = cell(n_features,1);
feature_names{1} = 'lowpass';
feature_names{2} = 'hor high-pass';
feature_names{3} = 'ver high-pass';
feature_names{4} = 'std hor high-pass';
feature_names{5} = 'std ver high-pass';
img_features = zeros(size(img,1),size(img,2),n_features);
img_features(:,:,1) = imfilter(img,filter_l);        % lowpass filter
img_features(:,:,2) = imfilter(img,filter_h);        % horizontal high-pass filter
img_features(:,:,3) = imfilter(img,filter_v);        % vertical high-pass filter
img_features(:,:,4) = stdfilt(img_features(:,:,2));  % local standard deviation of horizontal high-pass filter
img_features(:,:,5) = stdfilt(img_features(:,:,3));  % local standard deviation of vertical high-pass filter

% number of lines to draw/train the segmentation model
n_classes = 3;
class_names = cell(n_classes,1);
class_names{1} = 'background';
class_names{2} = 'hor textured';
class_names{3} = 'ver textured';
n_lines = 5;

% train the segmentation model
selections = train_model(img, n_classes, n_lines, class_names);

% segment for fibers
[L_S,H_S,V_S,F_S] = segment_fibers_2D(img, img_features, selections, ...
                                      filter_l, filter_h, filter_v, bg);
                                  
% show results
figure, imshow(uint16(img));
figure, imshow(uint16(drawmask(img,L_S)));
figure, imshow(uint16(drawmask(img,H_S)));
figure, imshow(uint16(drawmask(img,V_S)));
figure, imshow(uint16(drawmask(img,F_S)));
