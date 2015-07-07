
clear all;
close all;

% image
img_path = '/net/ipi/scratch/jbroels/microct/grondwaarden/1_0159.tif';
img = imread(img_path);
figure;
imshow(img,[]);

% groundtruth
% yarns perpendicular
img_gt_perp_path = '/net/ipi/scratch/jbroels/microct/grondwaarden/1_0159_yarns_perpendicular.png';
img_gt_perp = imread(img_gt_perp_path);
img_gt_perp = img_gt_perp < 2^8-1;
figure;
imshow(img_gt_perp,[]);

% groundtruth
% yarns parallel
img_gt_par_path = '/net/ipi/scratch/jbroels/microct/grondwaarden/1_0159_yarns_parallel.png';
img_gt_par = imread(img_gt_par_path);
img_gt_par = img_gt_par(:,:,2) > 100;
figure;
imshow(img_gt_par,[]);