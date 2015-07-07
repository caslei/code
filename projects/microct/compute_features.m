function X = compute_features(img, fg)

[M,N] = size(img);
wnd_size = 5;

[rows,cols] = find(fg);
n_samples = numel(rows);
n_features = 22;
X = zeros(n_samples,n_features);
for i=1:n_samples
    disp(num2str(i/n_samples));
    r = rows(i);
    c = cols(i);
    block = img(max(r-wnd_size,1):min(r+wnd_size,M),max(c-wnd_size,1):min(c+wnd_size,N));
    features = zeros(1,n_features);
    X(i,:) = features';
end

end

