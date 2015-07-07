function [noise, PS] = emnoise(sig, alpha, sigma_0, correlated)
% Simulates signal-dependent, correlated EM-noise.

if (nargin > 3 && ~correlated) % sigdependent uncorrelated noise
    [M,N] = size(sig);
    noise = randn(M,N);

    sigma = @(i) sqrt(alpha*i+sigma_0);
    noise = sigma(sig).*noise;

    P = abs(fft2(noise));
    P = P / sqrt(mean2(P.^2));
    PS = P.^2;
else % sigdependent correlated noise
    [M,N] = size(sig);
    noise = randn(M,N);

    load('noise_filter.mat');
    noise = conv2(noise, f', 'same');
    noise = noise / std2(noise);

    sigma = @(i) sqrt(alpha*i+sigma_0);
    noise = sigma(sig).*noise;

    P = abs(fft2(noise));
    P = P / sqrt(mean2(P.^2));
    PS = P.^2;
end