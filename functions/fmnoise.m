function noise = fmnoise(sig, alpha, sigma_0)
% Simulates signal-dependent, correlated EM-noise.

[M,N] = size(sig);
noise = randn(M,N);

sigma = @(i) sqrt(alpha*i+sigma_0);
noise = sigma(sig).*noise;
