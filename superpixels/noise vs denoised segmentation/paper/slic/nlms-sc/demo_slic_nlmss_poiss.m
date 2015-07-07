clear all;
close all;

%% Image path
im_noisy = 'noise-s.tif';
im_denoised = 'denoised-s.tif';
im_labels = 'labels-s.tif';
S = 200;

%% Read image data
disp('Reading image ...');
I = double(imread(im_noisy));
I = I(1:S,1:S);
J = zeros(size(I,1),size(I,2),3);
J(:,:,1) = I;
J(:,:,2) = I;
J(:,:,3) = I;
I = double(imread(im_denoised));
I = I(1:S,1:S);
K = zeros(size(I,1),size(I,2),3);
K(:,:,1) = I;
K(:,:,2) = I;
K(:,:,3) = I;

%% Read groundtruth image data
L = double(imread(im_labels));
L = L(1:S,1:S);
L = bwlabel(L);

%% Segmentation parameters
nbSegments = 250;
m = 10;
colopt = 'median';

%% Construct superpixels on noisy image
disp('Computing superpixels on noisy image ...');
tic;
[noise_labels, ~, ~] = slic(J, nbSegments, m);
noise_label_edges = edge(noise_labels,0.01);
t = toc;
disp(['Superpixels computed on noisy image. This took ' num2str(t) ' seconds.']);

%% Construct superpixels on denoised image
disp('Computing superpixels on denoised image ...');
tic;
[denoised_labels, ~, ~] = slic(K, nbSegments, m);
denoised_label_edges = edge(denoised_labels,0.01);
t = toc;
disp(['Superpixels computed on denoised image. This took ' num2str(t) ' seconds.']);

%% Compute quality measures
disp('Computing quality measures ...');
L_labels = imfill(L)+1;
u_e_noise = under_segmentation_error(L_labels, max(L_labels(:)), noise_labels, max(noise_labels(:)));
u_e_denoised = under_segmentation_error(L_labels, max(L_labels(:)), denoised_labels, max(denoised_labels(:)));
disp(['Under-segmentation error on noisy image: ' num2str(u_e_noise)]);
disp(['Under-segmentation error on denoised image: ' num2str(u_e_denoised)]);
% [rowsL, colsL] = find(L);
% [rowsN, colsN] = find(noise_label_edges);
% [rowsD, colsD] = find(denoised_label_edges);
% d_max_noise = hausdorffSuperPixel([rowsL, colsL], [rowsN, colsN], 0);
% d_mean_noise = hausdorffSuperPixel([rowsL, colsL], [rowsN, colsN], 1);
% d_max_denoised = hausdorffSuperPixel([rowsL, colsL], [rowsD, colsD], 0);
% d_mean_denoised = hausdorffSuperPixel([rowsL, colsL], [rowsD, colsD], 1);
[d_max_noise, d_mean_noise] = housedorf_superpixel(double(L), numel(unique(L))-1, double(noise_label_edges));
[d_max_denoised, d_mean_denoised] = housedorf_superpixel(double(L), numel(unique(L))-1, double(denoised_label_edges));
disp(['Haussdorf distances on noisy image: ' num2str(d_max_noise) ' (max) - ' num2str(d_mean_noise) ' (mean)']);
disp(['Haussdorf distances on denoised image: ' num2str(d_max_denoised) ' (max) - ' num2str(d_mean_denoised) ' (mean)']);

%% Plot results
C = J;
C(:,:,1) = C(:,:,1)-255*noise_label_edges;
C(:,:,2) = C(:,:,2)-255*noise_label_edges;
C(:,:,3) = C(:,:,3)-255*noise_label_edges;
C = max(C, 0);
D = K;
D(:,:,1) = D(:,:,1)-255*denoised_label_edges;
D(:,:,2) = D(:,:,2)-255*denoised_label_edges;
D(:,:,3) = D(:,:,3)-255*denoised_label_edges;
D = max(D, 0);
figure;
imshow(uint8(J));
figure;
imshow(uint8(K));
figure;
imshow(uint8(noise_labels)); colormap jet;
figure;
imshow(uint8(denoised_labels)); colormap jet;
figure;
imshow(uint8(C));
figure;
imshow(uint8(D));
figure;
imagesc(L);