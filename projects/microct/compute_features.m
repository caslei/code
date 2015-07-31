function img_features = compute_features(img,n_features,filter_l,filter_h,filter_v)

img_features = zeros(size(img,1),size(img,2),n_features);
img_features(:,:,1) = imfilter(img,filter_l);        % lowpass filter
img_features(:,:,2) = imfilter(img,filter_h);        % horizontal high-pass filter
img_features(:,:,3) = imfilter(img,filter_v);        % vertical high-pass filter
img_features(:,:,4) = stdfilt(img_features(:,:,2));  % local standard deviation of horizontal high-pass filter
img_features(:,:,5) = stdfilt(img_features(:,:,3));  % local standard deviation of vertical high-pass filter

end

