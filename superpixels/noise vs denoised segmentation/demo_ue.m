

im = '118035';

I = double(imread(strcat(im,'.jpg')));
load(strcat(im,'.mat'));
num_groundtruth = numel(groundTruth);
[L,M,N] = size(I);
b_im_gt = zeros(L,M);

% noise/denoising parameters
sigma_max = 500; 
alpha = 1; 
W = 3;
h = 2;
T = 0.7;
wnd_size = 5;
weighting_function_name = 'MODIFIED_BISQUARE'; 
V = 0;

% segmentation parameters
nbSegments = 50;
m = 10;
colopt = 'median';

u_e_noise = zeros(sigma_max,num_groundtruth);
u_e_denoised = zeros(sigma_max,num_groundtruth);
bar = waitbar(0,'Please wait...');
for sigma=1:sigma_max
    sigma_0 = (sigma/10)^2;

    noise_3d = zeros(size(I));
    PS_3d = zeros(size(I));
    J = I;
    for l=1:3
        [noise, PS] = emnoise(I(:,:,l), alpha, sigma_0);
        J(:,:,l) = J(:,:,l) + noise;
        noise_3d(:,:,l) = noise;
        PS_3d(:,:,l) = PS;
    end

    K = I;
    for j=1:3
        [D, ~, ~] = fNLMS_SC(J(:,:,j), J(:,:,j), h, T, PS_3d(:,:,j), alpha, sigma_0, W, wnd_size, weighting_function_name, V);
        K(:,:,j) = double(abs(D));
    end

    [SegLabel_noise, ~, ~] = slic(J, nbSegments, m);
    b_im_sa_noise = edge(SegLabel_noise,0.01);

    [SegLabel_denoised, ~, ~] = slic(K, nbSegments, m);
    b_im_sa_denoised = edge(SegLabel_denoised,0.01);

    for i=1:num_groundtruth
        b_im_gt = groundTruth{i}.Boundaries;
        BW = logical(1-b_im_gt);
        L = bwlabel(BW,4);
        se = strel('disk',1);
        SegLabel_gt = imdilate(L,se);

        u_e_noise(sigma,i) = under_segmentation_error(SegLabel_gt, max(SegLabel_gt(:)), SegLabel_noise, max(SegLabel_noise(:)));
        u_e_denoised(sigma,i) = under_segmentation_error(SegLabel_gt, max(SegLabel_gt(:)), SegLabel_denoised, max(SegLabel_denoised(:)));
    end

    waitbar(sigma/sigma_max)
end
close(bar)

figure;
plot(0.1:0.1:(sigma_max/10),sum(u_e_denoised,2)/num_groundtruth,0.1:0.1:(sigma_max/10),sum(u_e_noise,2)/num_groundtruth);