
N = 60;

hd_max_noises = zeros(1,N);
hd_mean_noises = zeros(1,N);
hd_max_denoiseds = zeros(1,N);
hd_mean_denoiseds = zeros(1,N);
for sigma_index=1:N
    sigma = sigma_index
    [hd_max_noise, hd_mean_noise, hd_max_denoised, hd_mean_denoised, C, D] = fbenchmark(sigma);
    hd_max_noises(sigma_index) = hd_max_noise;
    hd_mean_noises(sigma_index) = hd_mean_noise;
    hd_max_denoiseds(sigma_index) = hd_max_denoised;
    hd_mean_denoiseds(sigma_index) = hd_mean_denoised;
    % close all;
end

plot(1:N, hd_max_noises, 1:N, hd_mean_noises, 1:N, hd_max_denoiseds, 1:N, hd_mean_denoiseds);
legend('hd_max_noise','hd_mean_noise','hd_max_denoised','hd_mean_denoised');