clear all;
close all;

%% Image path
im_noisy = 'noise-sc.tif';
im_denoised = 'denoised-sc.tif';
im_labels = 'labels-sc-full.tif';
partial = 0;
S = 150;

%% Read image data
disp('Reading image ...');
I = double(imread(im_noisy));
if partial
    I = I(1:S,1:S);
end
J = zeros(size(I,1),size(I,2),3);
J(:,:,1) = I; J(:,:,2) = I; J(:,:,3) = I;
I = double(imread(im_denoised));
if partial
    I = I(1:S,1:S);
end
K = zeros(size(I,1),size(I,2),3);
K(:,:,1) = I; K(:,:,2) = I;K(:,:,3) = I;

%% Read groundtruth image data
L = double(imread(im_labels));
if partial
    L = L(1:S,1:S);
end

%% Segmentation parameters
nbSegments = 500;
m_noise = 25;
m_denoised = 10;

%% Construct superpixels on noisy image
disp('Computing superpixels on noisy image ...');
tic;
[noise_labels, ~, ~] = slic(J, nbSegments, m_noise);
noise_label_edges = edges(noise_labels);
t = toc;
disp(['Superpixels computed on noisy image. This took ' num2str(t) ' seconds.']);

%% Construct superpixels on denoised image
disp('Computing superpixels on denoised image ...');
tic;
[denoised_labels, ~, ~] = slic(K, nbSegments, m_denoised);
denoised_label_edges = edges(denoised_labels);
t = toc;
disp(['Superpixels computed on denoised image. This took ' num2str(t) ' seconds.']);

%% Compute quality measures
disp('Computing quality measures ...');
L_labels = imfill(L)+1;
u_e_noise = under_segmentation_error(L_labels, max(L_labels(:)), noise_labels, max(noise_labels(:)));
u_e_denoised = under_segmentation_error(L_labels, max(L_labels(:)), denoised_labels, max(denoised_labels(:)));
[d_max_noise, d_mean_noise] = housedorf_superpixel(double(L), numel(unique(L))-1, double(noise_label_edges));
[d_max_denoised, d_mean_denoised] = housedorf_superpixel(double(L), numel(unique(L))-1, double(denoised_label_edges));

%% Plot results
C = J;
C(:,:,1) = C(:,:,1)+255*noise_label_edges;
C(:,:,2) = C(:,:,2)-255*noise_label_edges;
C(:,:,3) = C(:,:,3)-255*noise_label_edges;
C = min(max(C, 0),255);
D = K;
D(:,:,1) = D(:,:,1)+255*denoised_label_edges;
D(:,:,2) = D(:,:,2)-255*denoised_label_edges;
D(:,:,3) = D(:,:,3)-255*denoised_label_edges;
D = min(max(D, 0),255);
figure;
imshow(uint8(C));
title({['Under-segmentation error on noisy image: ' num2str(u_e_noise)], ...
       ['Haussdorf distances on noisy image: ' num2str(d_max_noise) ' (max) - ' num2str(d_mean_noise) ' (mean)']});
figure;
imshow(uint8(D));
title({['Under-segmentation error on denoised image: ' num2str(u_e_denoised)], ...
       ['Haussdorf distances on denoised image: ' num2str(d_max_denoised) ' (max) - ' num2str(d_mean_denoised) ' (mean)']});