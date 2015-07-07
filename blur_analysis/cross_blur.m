
clear all;
close all;

load('average_horizontal_patch.mat')
sig_noiseless = average_patch;

[FX,FY] = gradient(sig_noiseless);
TY = 1;
se = strel('disk',5);
vertical_grad_opened = imopen(abs(FY)>TY, se);
vertical_grad_opened_thinned = bwmorph(vertical_grad_opened,'thin', Inf);

% figure;
% subplot(121),imshow(FY,[]),title(sprintf('Vertical derivative'));
% subplot(122),imshow(vertical_grad_opened,[]),title(sprintf('Vertical thresholded, opened derivative'));

% figure;
% subplot(121),imshow(vertical_grad_opened_thinned,[]),title(sprintf('Vertical thresholded, opened, thinned derivative'));
% subplot(122),imshow(sig_noiseless,[0 2^8-1]),title(sprintf('Denoised image'));

margin = 6;
sig_est_cropped = sig_noiseless(:,1+margin:end-margin);
vertical_got_cropped = vertical_grad_opened_thinned(:,1+margin:end-margin);

figure;
subplot(121),imshow(vertical_got_cropped,[]),title(sprintf('Vertical thresholded, opened, thinned, cropped derivative'));
subplot(122),imshow(sig_est_cropped,[0 2^8-1]),title(sprintf('Denoised, cropped image'));

[rows, cols] = find(vertical_got_cropped);
sig_artificial_top = zeros(size(sig_est_cropped,1), size(sig_est_cropped,2));
for i=1:numel(rows)
    row = rows(i);
    col = cols(i);
    sig_artificial_top(1:max(1, row), col) = 1;
end
sig_artificial_bottom = 1-sig_artificial_top;
% figure;
% subplot(121),imshow(sig_artificial_top,[]),title(sprintf('Top side'));
% subplot(122),imshow(sig_artificial_bottom,[]),title(sprintf('Bottom side'));

mean_top = mean(sig_est_cropped(sig_artificial_top==1));
mean_bottom = mean(sig_est_cropped(sig_artificial_bottom==1));
sig_artificial_top = sig_artificial_top.*mean_top;
sig_artificial_bottom = sig_artificial_bottom.*mean_bottom;
% figure;
% subplot(121),imshow(sig_artificial_top,[0 2^8-1]),title(sprintf('Top side'));
% subplot(122),imshow(sig_artificial_bottom,[0 2^8-1]),title(sprintf('Bottom side'));

% w = 0.75;
w = zeros(size(sig_est_cropped,1), size(sig_est_cropped,2));
lambda = 1;
for i=1:numel(cols)
    row = rows(i);
    col = cols(i);
    w(1:row,col) = exp(abs(row-(1:row))/lambda/abs(row))/exp(1/lambda);
    w(row+1:end,col) = exp(abs(row-(row+1:size(sig_est_cropped, 1)))/lambda/abs(row-size(sig_est_cropped, 1)))/exp(1/lambda);
end
% imagesc(w);colormap gray;
artificial_image = sig_artificial_top + sig_artificial_bottom;
artificial_image = w.*sig_est_cropped + (1-w).*artificial_image;
figure;
subplot(121),imshow(sig_est_cropped,[0 2^8-1]),title(sprintf('Denoised image'));
subplot(122),imshow(artificial_image,[0 2^8-1]),title(sprintf('Artificial image'));

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
plot(fftshift(estimated_kernel_1D));title(sprintf('Estimated vertical blur kernel'));
xlim([70 120])

save('estimated_vertical_kernel_1D.mat', 'estimated_kernel_1D');
