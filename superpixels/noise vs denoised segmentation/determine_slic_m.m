clear all;
close all;

m_ref1 = 10;
m_ref2 = 15;
m_ref3 = 20;
m_ref4 = 25;
m_max = 100;
im = 'noise-s.tif';
nbSegments = 100;
colopt = 'median';

I = double(imread(im));
I = I(1:100,1:100);
J = zeros(size(I,1),size(I,2),3);
J(:,:,1) = I;
J(:,:,2) = I;
J(:,:,3) = I;
I = J;

% params
sigma = 20; 
sigma_0 = sigma^2;
alpha = 1; 
W = 3;
% h = 2;
h = 2.4;
T = 0.7;
wnd_size = 5;
weighting_function_name = 'MODIFIED_BISQUARE'; 
V = 0;
% PS_3d = zeros(size(I));
% for i=1:3
%     [~, PS] = emnoise(I(:,:,i), alpha, sigma_0);
%     PS_3d(:,:,i) = PS;
% end

% denoise
K = I;
for i=1:3
    % [D, ~, ~] = fNLMS_SC(J(:,:,i), J(:,:,i), h, T, PS_3d(:,:,i), alpha, sigma_0, W, wnd_size, weighting_function_name, V);
    D = fNLMS_S(J(:,:,i), h, alpha, sigma_0, W, wnd_size, weighting_function_name, V);
    K(:,:,i) = double(abs(D));
end
figure;
subplot(1,2,1), subimage(uint8(J));
subplot(1,2,2), subimage(uint8(K));

% superpixels ref
[denoised_labels, ~, ~] = slic(K, nbSegments, m_ref1);
e_ref1 = compute_eccentricity(denoised_labels);
[denoised_labels, ~, ~] = slic(K, nbSegments, m_ref2);
e_ref2 = compute_eccentricity(denoised_labels);
[denoised_labels, ~, ~] = slic(K, nbSegments, m_ref3);
e_ref3 = compute_eccentricity(denoised_labels);
[denoised_labels, ~, ~] = slic(K, nbSegments, m_ref4);
e_ref4 = compute_eccentricity(denoised_labels);

e_s = zeros(1,m_max);
for m=1:m_max
    m
    [noise_labels, ~, ~] = slic(J, nbSegments, m);
    e_s(m) = compute_eccentricity(noise_labels);
end

figure;
plot(1:m_max,e_s);
hline = refline([0 e_ref1]);
hline = refline([0 e_ref2]);
hline = refline([0 e_ref3]);
hline = refline([0 e_ref4]);
legend('Noisy superpixels','Denoised superpixels (m=10)','Denoised superpixels (m=15)','Denoised superpixels (m=20)','Denoised superpixels (m=25)');