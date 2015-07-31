
clear all;
close all;

% read full image, select 1 slice for training
disp('reading 3D image data ...')
img_3D = imread3D('/net/ipi/scratch/jbroels/microct/reconstructed2/stack.tif');

slice_num = 200;

% load im.mat
img = squeeze(img_3D(slice_num,:,:));

% extract top and bottom background and set this to 0
T = 4000;
bg = imerode(imclose(img<T,strel('disk',3)),strel('disk',7));
img(logical(bg)) = 0;

% filters that will be used for feature extraction
filter_l = fspecial('average');
filter_h = fspecial('prewitt');
filter_v = filter_h';

% compute features
n_features = 5;
img_features = compute_features(img,n_features,filter_l,filter_h,filter_v);

% number of lines to draw/train the segmentation model
n_classes = 3;
class_names = cell(n_classes,1);
class_names{1} = 'background';
class_names{2} = 'hor textured';
class_names{3} = 'ver textured';
n_lines = 5;

% train the segmentation model
selections = train_model(img, n_classes, n_lines, class_names);
[ksd_fs, ksd_xs] = estimate_ksds(img_features, selections);
pms = compute_pms(img_features, ksd_xs, ksd_fs);
init_params = ones(n_features,n_classes)/n_features;
init_params(:,1) = [0.88 0.01 0.01 0.05 0.05];
init_params(:,2) = [0.40 0.00 0.30 0.00 0.30];
init_params(:,3) = [0.40 0.30 0.00 0.30 0.00];
f = select_optimal_params(init_params,pms,bg,img);
waitfor(f);
load temp.mat;
params = good_params;
clear good_params;

% segment slices for fibers 
F_3D = zeros(size(img_3D));
for n_slice=1:size(img_3D,1)
    imgt_features = compute_features(squeeze(img_3D(n_slice,:,:)),n_features,filter_l,filter_h,filter_v);
    pms = compute_pms(imgt_features, ksd_xs, ksd_fs);
    [~,~,~,F_S] = extract_segmentation(params,pms,bg);
    F_3D(n_slice,:,:) = F_S;
    disp(num2str(n_slice/size(img_3D,1)));
end
                                  
% save results
for i=1:size(F_3D,1)
    F_3D_i = squeeze(F_3D(i,:,:));
    save(['/net/ipi/scratch/jbroels/microct/segmentation results/F_3D_' num2str(i) '.mat'],'F_3D_i');
    disp(num2str(i/size(F_3D,1)));
end
