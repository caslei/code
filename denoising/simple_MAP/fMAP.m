function sig_est = fMAP(sig, lambda, filter_size, filter_sigma)

h = fspecial('gaussian', filter_size, filter_sigma);
sig_mean = filter2(h, sig);
sig_est = (sig+lambda.*sig_mean) ./ (1+lambda);

end

