% This script illustrates the Gaussian distribution of a zero signal 3D EM
% image. 
clear all;
close all;

zero_signal_image_path = 'ruis_1.tif';
nbins = 100;

I = double(imread(zero_signal_image_path));
I_noise = I - mean2(I);
std2(I_noise)

[M, N] = size(I_noise);

figure('Name','Noise distribution','NumberTitle','off');
h = histfit(reshape(I_noise, M*N, 1), nbins);
set(h(1),'Facecolor',[0.8 0.8 0.8]);
set(h(2),'Color',[1 0.2 0.2]);
xlabel('Intensiteit');
ylabel('Frequentie');
[mu, sigma] = normfit(reshape(I_noise, M*N, 1));
legend('Ruisdistributie','Gaussiaanse benadering');
title({strcat('\mu = ',num2str(mu)),strcat('\sigma = ',num2str(sigma))});

[histvalues, binpos] = hist(reshape(I_noise, 1, numel(I_noise)), nbins);
normhistvalues = histvalues / sum(histvalues);
fits = pdf('Normal',binpos,mu,sigma);
normfits = fits / sum(fits);

MSE = sum((normhistvalues - normfits).^2)