% Checks for stationarity by comparing the means and standard deviations of
% shifted areas around the middle nxn block. The parameter m specifies how
% far to shift.
function [means, stds] = noise_stationarity(I_noise, n, m)

[N, M] = size(I_noise);

% Invalid cases
if (n+2*m > min(N,M) || n > min(N,M) || n+m > min(N,M))
    means = 0;
    stds = 0;
    return;
end

% Center coordinate
x_c = floor((N-n)/2);
y_c = floor((M-n)/2);

means = zeros(2*m+1);
stds = zeros(2*m+1);

h = waitbar(0,'Busy ...');

for i=-m:m
    for j=-m:m
        % Construct block to observe
        x = x_c+i;
        y = y_c+j;
        block = I_noise(x+1:x+n,y+1:y+n);
        
        % Analyse block
        [M, N] = size(block);
        [mu, sigma] = normfit(reshape(double(block), M*N, 1));
        means(i+m+1,j+m+1) = mu;
        stds(i+m+1,j+m+1) = sigma;
    end
    waitbar((i+m+1)/(2*m+1));
end

close(h);