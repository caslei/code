% based on a training set of points, this function will extract a
% segmentation of the background, horizontally and vertically textured
% fibers.
% additionally, a segmentation of the merged fibers is also returned
function [L_S,H_S,V_S,F_S] = segment_fibers_2D(img, img_features, selections, ...
                                               filter_l,filter_h,filter_v, bg)

n_features = size(img_features,3);
n_classes = size(selections,3);

% estimate kernel smoothing functions: XY_ksd_f expresses the probability
% that feature outcome X of a pixel corresponds to pixel class Y
% disp('computing kernel smoothing functions ...');
[ksd_fs, ksd_xs] = estimate_ksds(img_features, selections);

% figure;
% for nc = 1:n_classes
%     for nf = 1:n_features
%         subplot(n_classes,n_features,(nf-1)*n_classes+nc)
%         plot(ksd_xs{nf,nc},ksd_fs{nf,nc});
%     end
% end

% extract features
% disp('extracting features ...');
imgt_features = zeros(size(img,1),size(img,2),n_features);
imgt_features(:,:,1) = imfilter(img,filter_l);        % lowpass filter
imgt_features(:,:,2) = imfilter(img,filter_h);        % horizontal high-pass filter
imgt_features(:,:,3) = imfilter(img,filter_v);        % vertical high-pass filter
imgt_features(:,:,4) = stdfilt(imgt_features(:,:,2)); % local standard deviation of horizontal high-pass filter
imgt_features(:,:,5) = stdfilt(imgt_features(:,:,3)); % local standard deviation of vertical high-pass filter

% compute probability maps
% disp('computing probability maps ...');
pms = compute_pms(imgt_features, ksd_xs, ksd_fs);

% figure;
% for nc = 1:n_classes
%     for nf = 1:n_features
%         subplot(n_classes,n_features,(nf-1)*n_classes+nc)
%         imshow(pms{nf,nc},[]); 
%     end
% end

% combine probability maps to class probability maps
% disp('combining probability maps to class probability maps ...');
init_params = ones(n_features,n_classes)/n_features;
init_params(:,1) = [0.88 0.01 0.01 0.05 0.05];
init_params(:,2) = [0.40 0.00 0.30 0.00 0.30];
init_params(:,3) = [0.40 0.30 0.00 0.30 0.00];
f = select_optimal_params(init_params,pms,bg,img);
waitfor(f);
load temp.mat;
params = good_params;
clear good_params;

[L_S,H_S,V_S,F_S] = extract_segmentation(params,pms,bg);


end