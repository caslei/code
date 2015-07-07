

im = '118035';

I = double(imread(strcat(im,'.jpg')));
load(strcat(im,'.mat'));
num_groundtruth = numel(groundTruth);
[L,M,N] = size(I);
b_im_gt = zeros(L,M);
for i=1:num_groundtruth
    b_im_gt = b_im_gt + groundTruth{i}.Boundaries;
end
b_im_gt = min(b_im_gt, 1);

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

%b_rs_noise = zeros(1,sigma_max);
%b_rs_denoised = zeros(1,sigma_max);
%bar = waitbar(0,'Please wait...');
%for sigma=1:sigma_max
    sigma = 5;
    sigma_0 = (sigma/10)^2;
    
    noise_3d = zeros(size(I));
    PS_3d = zeros(size(I));
    J = I;
    for i=1:3
        [noise, PS] = emnoise(I(:,:,i), alpha, sigma_0);
        J(:,:,i) = J(:,:,i) + noise;
        noise_3d(:,:,i) = noise;
        PS_3d(:,:,i) = PS;
    end

    K = I;
    for i=1:3
        [D, ~, ~] = fNLMS_SC(J(:,:,i), J(:,:,i), h, T, PS_3d(:,:,i), alpha, sigma_0, W, wnd_size, weighting_function_name, V);
        K(:,:,i) = double(abs(D));
    end

    [SegLabel, ~, ~] = slic(J, nbSegments, m);
    b_im_sa_noise = edge(SegLabel,0.01);
    figure(1); imagesc(b_im_sa_noise); colormap gray;

    [SegLabel, ~, ~] = slic(K, nbSegments, m);
    b_im_sa_denoised = edge(SegLabel,0.01);
    figure(2); imagesc(b_im_sa_denoised); colormap gray;
    
    b_rs_noise = boundary_precision(double(b_im_gt), double(b_im_sa_noise), 2);
    b_rs_denoised = boundary_precision(double(b_im_gt), double(b_im_sa_denoised), 2);
    
    %waitbar(sigma/sigma_max)

%end
%close(bar)

figure;
plot(0.1:0.1:(sigma_max/10),b_rs_denoised,0.1:0.1:(sigma_max/10),b_rs_noise);