% This script illustrates the stationarity of a zero signal 3D EM
% image. 
clear all;
close all;

signal_image_path = '001-46.tif';
n = 20; % Block size
m = 50; % Maximal shift distance

I = double(imread(signal_image_path));
mean = mean2(I)

[M, N] = size(I);
I_noise = I - mean2(I);

[means, stds] = noise_stationarity(I_noise, n, m);
mean_means = sum(sum(means))/(2*m)^2;
mean_stds = sum(sum(stds))/(2*m)^2;
std_means = std(std(means));
std_stds = std(std(stds))

figure('Name','Means','NumberTitle','off');
colormap(gray);
imagesc(means);
title({'Means', strcat('Mean means: ', num2str(mean_means)), strcat('Standard deviation means: ', num2str(std_means))});

figure('Name','Standard deviations','NumberTitle','off');
colormap(gray);
imagesc(stds);
title({'Standard deviations', strcat('Mean stds: ', num2str(mean_stds)), strcat('Standard deviation stds: ', num2str(std_stds))});