
 clear all;
 close all;

load('average_vertical_patch.mat')
sig_noiseless = average_patch;

[FX,FY] = gradient(sig_noiseless);
TX = 1.5;
se = strel('disk',5);
horizontal_grad_opened = imopen(abs(FX)>TX, se);
horizontal_grad_opened_thinned = bwmorph(horizontal_grad_opened,'thin', Inf);

% figure;
% subplot(121),imshow(FX,[]),title(sprintf('Horizontal derivative'));
% subplot(122),imshow(horizontal_grad_opened,[]),title(sprintf('Horizontal thresholded, opened derivative'));

 figure;
 subplot(121),imshow(horizontal_grad_opened_thinned,[]),title(sprintf('Horizontal thresholded, opened, thinned derivative'));
 subplot(122),imshow(sig_noiseless,[0 2^8-1]),title(sprintf('Denoised image'));

margin = 6;
sig_est_cropped = sig_noiseless(1+margin:end-margin,:);
horizontal_got_cropped = horizontal_grad_opened_thinned(1+margin:end-margin,:);

figure;
subplot(121),imshow(horizontal_got_cropped,[]),title(sprintf('Horizontal thresholded, opened, thinned, cropped derivative'));
subplot(122),imshow(sig_est_cropped,[0 2^8-1]),title(sprintf('Denoised, cropped image'));

[rows, cols] = find(horizontal_got_cropped);
sig_artificial_left = zeros(size(sig_est_cropped,1), size(sig_est_cropped,2));
for i=1:numel(rows)
    row = rows(i);
    col = cols(i);
    sig_artificial_left(row, 1:max(1, col)) = 1;
end
sig_artificial_right = 1-sig_artificial_left;
% figure;
% subplot(121),imshow(sig_artificial_left,[]),title(sprintf('Left side'));
% subplot(122),imshow(sig_artificial_right,[]),title(sprintf('Right side'));

mean_left = mean(sig_est_cropped(sig_artificial_left==1));
mean_right = mean(sig_est_cropped(sig_artificial_right==1));
sig_artificial_left = sig_artificial_left.*mean_left;
sig_artificial_right = sig_artificial_right.*mean_right;
% figure;
% subplot(121),imshow(sig_artificial_left,[0 2^8-1]),title(sprintf('Left side'));
% subplot(122),imshow(sig_artificial_right,[0 2^8-1]),title(sprintf('Right side'));

% w = 0.75;
w = zeros(size(sig_est_cropped,1), size(sig_est_cropped,2));
lambda = 1;
for i=1:numel(rows)
    row = rows(i);
    col = cols(i);
    w(row,1:col) = exp(abs(col-(1:col))/lambda/abs(col))/exp(1/lambda);
    w(row,col+1:end) = exp(abs(col-(col+1:size(sig_est_cropped, 2)))/lambda/abs(col-size(sig_est_cropped, 2)))/exp(1/lambda);
end
% imagesc(w);colormap gray;
artificial_image = sig_artificial_left + sig_artificial_right;
artificial_image = w.*sig_est_cropped + (1-w).*artificial_image;
figure;
subplot(121),imshow(sig_est_cropped,[]),title(sprintf('Denoised image'));
subplot(122),imshow(artificial_image,[]),title(sprintf('Artificial image'));

fft_sig_est_cropped = fft2(sig_est_cropped);
fft_artificial_image = fft2(artificial_image);
% figure;
% subplot(121),imshow(log(abs(fft_sig_est_cropped)+1),[]),title(sprintf('Denoised image (frequency domain)'));
% subplot(122),imshow(log(abs(fft_artificial_image)+1),[]),title(sprintf('Artificial image (frequency domain)'));

fft_estimated_kernel = fft_sig_est_cropped./fft_artificial_image;
estimated_kernel = ifft2(fft_estimated_kernel);
figure;
subplot(121),imshow(fftshift(estimated_kernel),[]),title(sprintf('Estimated blur kernel'));
subplot(122),imshow(log(abs(fft_estimated_kernel)+1),[]),title(sprintf('Estimated blur kernel (frequency domain)'));

estimated_kernel_1D = estimated_kernel(1,:);
figure;
plot(fftshift(estimated_kernel_1D));title(sprintf('Estimated horizontal blur kernel'));
xlim([80 120])

save('estimated_horizontal_kernel_1D.mat', 'estimated_kernel_1D');
