clear all;

%% Parameters
im_name = '//ipi/research/jbroels/images/512x512/lena.tif'; 

raw_denoising = 0;
if strcmp(im_name, 'em1.tif') || strcmp(im_name, 'em2.tif') || strcmp(im_name, 'em3.tif')
    raw_denoising = 1; 
end

% Blur parameters
add_blur = 0; % Stel dit in op 1 om blur toe te voegen, 0 om dit niet te doen
filter_size_blur = 3;
filter_sigma_blur = 1;

% Ruis parameters
em_noise = 1; % Stel dit in op 1 om gecorreleerde, signaalafhankelijke ruis toe te voegen
              % Stel dit in op 0 om witte, signaalonafhankelijke Gaussiaanse ruis toe te voegen
sigma = 20; % Ruis standaardafwijking
alpha = 1; % Signaalafhankelijkheid
sigma_0 = sigma^2;

%% Laad beeld
sig_orig = double(imread(im_name)); 
%% 

%% Aanmaak van het (geblurred) ruizig beeld
if raw_denoising
    sig = normalise(sig_orig);
else
    [M,N]=size(sig_orig);
    sig = sig_orig;
    if add_blur
        G = fspecial('gaussian', filter_size_blur, filter_sigma_blur);
        sig = filter2(G, sig);
    end
    if em_noise
        [noise, PS] = emnoise(sig_orig, alpha, sigma_0);
    else
        noise = sigma*randn(M,N);
    end
    sig = sig + noise;
end
%% 

%% BM3D
sig_est = fBM3D(sig, 2*sigma);
%% 

%%

%% Weergave van het resultaat
figure,
if raw_denoising
    subplot(121),imshow(sig,[]),title(sprintf('Gedegregadeerd beeld'));
    subplot(122),imshow(sig_est,[]),title(sprintf('Gereconstrueerd beeld'));
else
    subplot(131),imshow(sig_orig(2:end,2:end),[0,255]);
    subplot(132),imshow(sig(2:end,2:end),[0,255]),title(sprintf('Gedegregadeerd beeld PSNR=%f dB', PSNR(sig(2:end,2:end),sig_orig(2:end,2:end))));
    subplot(133),imshow(sig_est(2:end,2:end),[0,255]),title(sprintf('Gereconstrueerd beeld PSNR=%f dB', PSNR(sig_est(2:end,2:end),sig_orig(2:end,2:end))));
    % subplot(131),imshow(sig_orig(2:end,2:end),[]);
    % subplot(132),imshow(sig(2:end,2:end),[]),title(sprintf('Gedegregadeerd beeld PSNR=%f dB', PSNR(sig(2:end,2:end),sig_orig(2:end,2:end))));
    % subplot(133),imshow(sig_est(2:end,2:end),[]),title(sprintf('Gereconstrueerd beeld PSNR=%f dB', PSNR(sig_est(2:end,2:end),sig_orig(2:end,2:end))));
end
%% 