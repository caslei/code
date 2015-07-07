% This script illustrates the Gaussian distribution of a 3D EM
% image. 
% In order to obtain a noise signal, the mean intensity is subtracted from
% the image. Therefore, it is assumed the image is that of a 'constant'
% area.
clear all;
close all;

k = 1;

signal_image_path = strcat('001-',num2str(k),'.tif');
nbins = 100;

I = double(imread(signal_image_path));
[M, N] = size(I);
mean = mean2(I);
I_noise = I - mean2(I);

figure('Name','Noise distribution','NumberTitle','off');
h = histfit(I_noise(:), nbins);
set(h(1),'Facecolor',[0.8 0.8 0.8]);
set(h(2),'Color',[1 0.2 0.2]);
xlabel('Intensity');
ylabel('Frequency');
[mu, sigma] = normfit(I_noise(:));
legend('Noise frequency','Fitted curve');
title({strcat('\mu = ',num2str(mu)),strcat('\sigma = ',num2str(sigma))});

[histvalues, binpos] = hist(I_noise(:), nbins);
normhistvalues = histvalues / sum(histvalues);
fits = pdf('Normal',binpos,mu,sigma);
normfits = fits / sum(fits);

MSE = sum((normhistvalues - normfits).^2)/nbins