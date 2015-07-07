clear all;

%% Parameters
im_name = 'barbara.tif'; 

raw_denoising = 0;
if strcmp(im_name, 'em1.tif') || strcmp(im_name, 'em2.tif') || strcmp(im_name, 'em3.tif')
    raw_denoising = 1; 
end

% Blur parameters
add_blur = 1;
filter_size_blur = 3;
filter_sigma_blur = 1;

% Ruis parameters
em_noise = 1; % Stel dit in op 1 om gecorreleerde, signaalafhankelijke ruis toe te voegen
              % Stel dit in op 0 om witte, signaalonafhankelijke Gaussiaanse ruis toe te voegen
sigma = 20; % Ruis standaardafwijking
alpha = 1; % Signaalafhankelijkheid
sigma_0 = sigma^2;

%% MAP parameters
filter_size = 7;
filter_sigma = 5;
lambda = 5;
%%

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

%% Anisotrope diffusie
sig_est = fMAP(sig, lambda, filter_size, filter_sigma);
%% 

%%

%% Weergave van het resultaat
figure,
if raw_denoising
    subplot(121),imshow(sig,[]),title(sprintf('Gedegregadeerd beeld'));
    subplot(122),imshow(sig_est,[]),title(sprintf('Gereconstrueerd beeld'));
else
    subplot(121),imshow(sig,[]),title(sprintf('Gedegregadeerd beeld PSNR=%f dB', PSNR(sig,sig_orig)));
    subplot(122),imshow(sig_est,[]),title(sprintf('Gereconstrueerd beeld PSNR=%f dB', PSNR(sig_est,sig_orig)));
end
%% 