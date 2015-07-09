
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
if ~segment_3D
    bg = imerode(imclose(img<T,strel('disk',3)),strel('disk',7));
else
    bg = zeros(size(img));
    h = waitbar(0,'computing background ...');
    for ns=1:size(img,3)
        bg(:,:,ns) = imerode(imclose(img(:,:,ns)<T,strel('disk',3)),strel('disk',7));
        waitbar(ns/size(img,3))
    end
    close(h);
end
img(logical(bg)) = 0;

% filters that will be used for feature extraction
filter_l = fspecial('average');
filter_h = fspecial('prewitt');
filter_v = filter_h';

% compute features
n_features = 5;
feature_names = cell(n_features,1);
feature_names{1} = 'lowpass';
feature_names{2} = 'hor high-pass';
feature_names{3} = 'ver high-pass';
feature_names{4} = 'std hor high-pass';
feature_names{5} = 'std ver high-pass';
if ~segment_3D
    img_features = zeros(size(img,1),size(img,2),n_features);
    img_features(:,:,1) = imfilter(img,filter_l);        % lowpass filter
    img_features(:,:,2) = imfilter(img,filter_h);        % horizontal high-pass filter
    img_features(:,:,3) = imfilter(img,filter_v);        % vertical high-pass filter
    img_features(:,:,4) = stdfilt(img_features(:,:,2));  % local standard deviation of horizontal high-pass filter
    img_features(:,:,5) = stdfilt(img_features(:,:,3));  % local standard deviation of vertical high-pass filter
else
    img_features = zeros(size(img,1),size(img,2),size(img,3),n_features);
    h = waitbar(0,'computing features ...');
    for ns=1:size(img,3)
        img_features(:,:,ns,1) = imfilter(img(:,:,ns),filter_l);   % lowpass filter
        img_features(:,:,ns,2) = imfilter(img(:,:,ns),filter_h);   % horizontal high-pass filter
        img_features(:,:,ns,3) = imfilter(img(:,:,ns),filter_v);   % vertical high-pass filter
        img_features(:,:,ns,4) = stdfilt(img_features(:,:,ns,2));  % local standard deviation of horizontal high-pass filter
        img_features(:,:,ns,5) = stdfilt(img_features(:,:,ns,3));  % local standard deviation of vertical high-pass filter
        waitbar(ns/size(img,3))
    end
    close(h);
end

% number of lines to draw/train the segmentation model
n_classes = 3;
class_names = cell(n_classes,1);
class_names{1} = 'background';
class_names{2} = 'hor textured';
class_names{3} = 'ver textured';
n_lines = 5;

% train the segmentation model
if ~segment_3D
    selections = train_model(img, n_classes, n_lines, class_names);
else
    selections = train_model(img(:,:,slice_num), n_classes, n_lines, class_names);
end


% segment for fibers 
if ~segment_3D
    [L_S,H_S,V_S,F_S] = segment_fibers_2D(img, img_features, selections, ...
                                          filter_l, filter_h, filter_v, bg);
else
    [L_S,H_S,V_S,F_S] = segment_fibers_3D(img, slice_num, img_features, selections, ...
                                          filter_l, filter_h, filter_v, bg);
end
                                  
% show results
if ~segment_3D
    figure, imshow(uint16(img));
    figure, imshow(uint16(drawmask(img,L_S)));
    figure, imshow(uint16(drawmask(img,H_S)));
    figure, imshow(uint16(drawmask(img,V_S)));
    figure, imshow(uint16(drawmask(img,F_S)));
else 
    save('L_S.mat','L_S');
    save('H_S.mat','H_S');
    save('V_S.mat','V_S');
    save('F_S.mat','F_S');
end
