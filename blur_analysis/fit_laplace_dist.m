
clear all;
close all;

% Horizontal kernel
load('estimated_horizontal_kernel_1D.mat');

kernel = fftshift(estimated_kernel_1D);
M = numel(kernel);

x0 = 1:M;
x1 = 1:0.1:M;
mu = M/2+1;
b = 1.7;
y = laplacedist(x1, mu, b);

figure;
plot(x0, kernel, 'g--o', x1, y, 'r'); title('Horizontal Laplacian kernel fit');

% Vertical kernel
load('estimated_vertical_kernel_1D.mat');

kernel = fftshift(estimated_kernel_1D);
M = numel(kernel);

x0 = 1:M;
x1 = 1:0.1:M;
mu = M/2+1;
b = 2.6;
y = laplacedist(x1, mu, b);

figure;
plot(x0, kernel, 'g--o', x1, y, 'r'); title('Vertical Laplacian kernel fit');
