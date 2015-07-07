% This script illustrates the Power Spectral Density of a 3D EM
% image. 
% In order to obtain a noise signal, the mean intensity is subtracted from
% the image. Therefore, it is assumed the image is that of a 'constant'
% area.
% Because of the vertical invariance, a vertical averaging plot is shown.
clear all;
% close all;

signal_image_path = '001-1.tif';

I = double(imread(signal_image_path));
I = I(1:1000,1:1000);

[M, N] = size(I);
I_noise = I - sum(sum(I))/(M*N);

F = fftshift(fft2(I_noise));
PSD = abs(F).^2;
figure('Name','Power Spectral Density','NumberTitle','off');
colormap(gray);
PSD = log(PSD+1);
PSD = uint16((PSD-min(min(PSD)))/max(max(PSD))*2^16);
PSD = imadjust(PSD,stretchlim(PSD, 0.0005),[]);
imagesc(PSD);
xlabel('Horizontal frequency f_x');
ylabel('Vertical frequency f_y');
title('Power Spectral Density');

figure('Name','Vertical averaging plot','NumberTitle','off');
plot(sum(PSD)/size(PSD,1));
xlabel('Horizontal frequency f_x');
ylabel('Spectral power');
title('Power Spectral Density (Average rows)');