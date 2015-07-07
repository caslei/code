function psnr = PSNR(A, B)
% Compute the Peak Signal to Noise Ratio of two images

nbits = 8;

mse = MSE(double(A), double(B));
psnr = 10 * log10((2^nbits-1)^2 / mse);