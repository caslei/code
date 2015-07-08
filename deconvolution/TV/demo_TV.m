
clear all;
close all;

img = double(imread('//ipi/research/jbroels/images/512x512/lena.tif'));

% blur params
f_size = 7;
f_sigma = 3;
blur_kernel = fspecial('gaussian', f_size, f_sigma);

img_blurred = imfilter(img, blur_kernel, 'symmetric');

% noise params
sigma_0 = 20; 
alpha = 0.05; 

em_corr_filter = [-0.005860504805239,...
                  -0.004145631049324,...
                  -0.007101863416801,...
                  -0.014007610052560,...
                  -0.018027659775297,...
                  -0.020445501436001,...
                  -0.022359319281906,...
                  -0.027855476658843,...
                  -0.037852223103446,...
                  -0.061583547802863,...
                  -0.105639357469836,...
                  -0.204771839660892,...
                  -0.362827110355747,...
                  -0.494054551997909,...
                   0.570451552004579,...
                   2.632161289724167,...
                   0.570451552004579,...
                  -0.494054551997909,...
                  -0.362827110355747,...
                  -0.204771839660892,...
                  -0.105639357469836,...
                  -0.061583547802863,...
                  -0.037852223103446,...
                  -0.027855476658843,...
                  -0.022359319281906,...
                  -0.020445501436001,...
                  -0.018027659775297,...
                  -0.014007610052560,...
                  -0.007101863416801,...
                  -0.004145631049324,...
                  -0.005860504805239];

em_corr_filter_inv =  [0.010323879069783,...
                       0.010370735399349,...
                       0.010891887108576,...
                       0.012328012363843,...
                       0.013008813866401,...
                       0.014891073349192,...
                       0.015807804797114,...
                       0.019160308488332,...
                       0.019906889609562,...
                       0.027474521331366,...
                       0.024528903211449,...
                       0.047905035553926,...
                       0.016986801150247,...
                       0.129162751099163,...
                      -0.122060533822016,...
                       0.498626234847429,...
                      -0.122060533822016,...
                       0.129162751099163,...
                       0.016986801150247,...
                       0.047905035553926,...
                       0.024528903211449,...
                       0.027474521331366,...
                       0.019906889609562,...
                       0.019160308488332,...
                       0.015807804797114,...
                       0.014891073349192,...
                       0.013008813866401,...
                       0.012328012363843,...
                       0.010891887108576,...
                       0.010370735399348,...
                       0.010323879069783];

noise = randn(size(img));
noise = imfilter(noise, em_corr_filter, 'symmetric');
noise = noise / std2(noise);
sigma = sigma_0*ones(size(img)) + alpha*img;

img_blurred_noisy = img_blurred + sigma.*noise;

% grad desc params
num_iter = 40;

% regularization params
lambda = 100;

tic
img_est_deconv = fTV(img_blurred_noisy, blur_kernel, lambda, ...
                     zeros(size(img)), num_iter);
toc

figure; imshow(img_blurred_noisy,[0,255]);
figure; imshow(img_est_deconv,[0,255]);
disp(['Original image (PSNR=' num2str(PSNR(img_blurred_noisy,img)) 'dB)']);
disp(['Deconvonoised image (PSNR=' num2str(PSNR(img_est_deconv,img)) 'dB)']);
