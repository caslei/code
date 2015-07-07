% This script illustrates the stationarity of a zero signal 3D EM
% image. 
clear all;
close all;

zero_signal_image_path = 'ruis_1.tif';
n = 20; % Block size
m = 100; % Maximal shift distance

I_noise = double(imread(zero_signal_image_path));

[means, stds] = noise_stationarity(I_noise, n, m);
mean_means = sum(sum(means))/(2*m)^2;
mean_stds = sum(sum(stds))/(2*m)^2;
std_means = std(std(means));
std_stds = std(std(stds))

figure('Name','Means','NumberTitle','off');
colormap(gray);
imagesc(means);
% title({'Means', strcat('Mean means: ', num2str(mean_means)), strcat('Standard deviation means: ', num2str(std_means))});
title('Means');

figure('Name','Standard deviations','NumberTitle','off');
colormap(gray);
imagesc(stds);
% title({'Standard deviations', strcat('Mean stds: ', num2str(mean_stds)), strcat('Standard deviation stds: ', num2str(std_stds))});
title('Standard deviations');