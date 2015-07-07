% This script illustrates the Power Spectral Density of a zero signal 3D EM
% image. 
% Because of the vertical invariance, a vertical averaging plot is shown.
clear all;
close all;

zero_signal_image_path = '/ipi/shared/biology/dmbr/SBF-SEM/beam-off/variable dwell-time/dwell0.5.dm3';

% I_noise = double(imread(zero_signal_image_path));
I_noise = dmread(zero_signal_image_path);
I_noise = double(I_noise);

F = fft2(I_noise);
PSD = abs(F);
% figure('Name','Power Spectral Density','NumberTitle','off');
% colormap(gray);
% % PSD = log(PSD+1);
% % PSD = uint16((PSD-min(min(PSD)))/max(max(PSD))*2^16);
% % PSD = imadjust(PSD,stretchlim(PSD, 0.0005),[]);
% imagesc(PSD);
% xlabel('Horizontal frequency f_x');
% ylabel('Vertical frequency f_y');
% title('Power Spectral Density');
% 
% figure('Name','Vertical averaging plot','NumberTitle','off');
% plot(sum(PSD)/size(PSD,1));
% xlabel('Horizontal frequency f_x');
% ylabel('Spectral power');
% title('Power Spectral Density (Average rows)');

figure('Name','Autocorrelation function','NumberTitle','off');
colormap(gray);
ACF = fftshift(ifft2(PSD));
imagesc(ACF);
xlabel('Relative horizontal position');
ylabel('Relative vertical position');
title('Autocorrelation function');

center_row = ceil((size(PSD,1)+1)/2);
center_col = ceil((size(PSD,2)+1)/2);
filter_size = 12;
ACF_filter = ACF(center_row,center_col-filter_size:center_col+filter_size);
ACF_filter = ACF_filter / sum(ACF_filter);
figure('Name','Correlation filter','NumberTitle','off');
plot(ACF_filter);
