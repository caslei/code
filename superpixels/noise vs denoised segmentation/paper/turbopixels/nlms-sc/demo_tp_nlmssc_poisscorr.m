
%% Image path
bsd_num = '118035';
im = strcat(bsd_num,'.jpg');

%% Read image data
disp('Reading image ...');
I = double(imread(im));

%% Read groundtruth image data
disp('Reading groundtruth data ...');
load(strcat(bsd_num,'.mat'));
num_groundtruth = numel(groundTruth);
[L,M,N] = size(I);
b_im_gt = zeros(L,M,num_groundtruth);
for i=1:num_groundtruth
    b_im_gt(:,:,i) = groundTruth{i}.Boundaries;
end

%% Noise/denoising parameters
sigma = 20; 
sigma_0 = (sigma/10)^2;
alpha = 1; 
W = 3;
h = 2;
T = 0.7;
wnd_size = 5;
weighting_function_name = 'MODIFIED_BISQUARE'; 
V = 0;

%% Segmentation parameters
nbSegments = 150;
m = 10;
colopt = 'median';

%% Construct noisy image
disp('Constructing noisy image ...');
noise_3d = zeros(size(I));
PS_3d = zeros(size(I));
J = I;
for i=1:3
    [noise, PS] = emnoise(I(:,:,i), alpha, sigma_0);
    J(:,:,i) = J(:,:,i) + noise;
    noise_3d(:,:,i) = noise;
    PS_3d(:,:,i) = PS;
end

%% Denoise noisy image
disp('Denoising noisy image ...');
K = I;
tic
for i=1:3
    [D, ~, ~] = fNLMS_SC(J(:,:,i), J(:,:,i), h, T, PS_3d(:,:,i), alpha, sigma_0, W, wnd_size, weighting_function_name, V);
    K(:,:,i) = double(abs(D));
end
t = toc;
disp(['Image denoised. This took ' num2str(t) ' seconds.']);

%% Construct superpixels on noisy image
disp('Computing superpixels on noisy image ...');
tic;
[~,noise_label_edges,~] = turbopixels(J, nbSegments);
noise_label_edges = double(noise_label_edges);
noise_label_edges_inv_logical = logical(1-noise_label_edges);
noise_label_edges_labeled = bwlabel(noise_label_edges_inv_logical,4);
se = strel('disk',2);
noise_labels = imdilate(noise_label_edges_labeled,se);
t = toc;
disp(['Superpixels computed on noisy image. This took ' num2str(t) ' seconds.']);

%% Construct superpixels on denoised image
disp('Computing superpixels on denoised image ...');
tic;
[~,denoised_label_edges,~] = turbopixels(K, nbSegments);
denoised_label_edges = double(denoised_label_edges);
denoised_label_edges_inv_logical = logical(1-denoised_label_edges);
denoised_label_edges_labeled = bwlabel(denoised_label_edges_inv_logical,4);
se = strel('disk',2);
denoised_labels = imdilate(denoised_label_edges_labeled,se);
t = toc;
disp(['Superpixels computed on denoised image. This took ' num2str(t) ' seconds.']);

%% Compute quality measures
disp('Computing quality measures ...');
u_e_noise = zeros(1,num_groundtruth);
u_e_denoised = zeros(1,num_groundtruth);
for i=1:num_groundtruth
    BW = logical(1-b_im_gt(:,:,i));
    L = bwlabel(BW,4);
    se = strel('disk',1);
    label_gt = imdilate(L,se);

    u_e_noise(i) = under_segmentation_error(label_gt, max(label_gt(:)), noise_labels, max(noise_labels(:)));
    u_e_denoised(i) = under_segmentation_error(label_gt, max(label_gt(:)), denoised_labels, max(denoised_labels(:)));
end
u_e_noise = mean(u_e_noise);
u_e_denoised = mean(u_e_denoised);
disp(['Under-segmentation error on noisy image: ' num2str(u_e_noise)]);
disp(['Under-segmentation error on denoised image: ' num2str(u_e_denoised)]);

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
imshow(uint8(C));
figure;
imshow(uint8(D));