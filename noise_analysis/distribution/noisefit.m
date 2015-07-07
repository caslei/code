% Plots the distribution of noise in an image by subtracting the mean
% intensity.
% It is also possible to fit the distribution with a Gaussian curve for
% which the mean and standard deviation are returned. 
function [mu, sigma] = noisefit(I, showfittedcurve)

[M, N] = size(I);
I_noise = I - sum(sum(I))/(M*N);

nbins = 100;

figure('Name','Noise distribution','NumberTitle','off');
h = histfit(reshape(double(I_noise), M*N, 1), nbins);
set(h(1),'Facecolor',[0.8 0.8 0.8]);
set(h(2),'Color',[1 0.2 0.2]);
if (~showfittedcurve)
    set(h(2),'HandleVisibility', 'off');
    set(h(2),'Visible','off');
end
legend('Noise frequency','Fitted curve');

[mu, sigma] = normfit(reshape(double(I_noise), M*N, 1));