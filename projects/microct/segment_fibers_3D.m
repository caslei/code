% based on a training set of points, this function will extract a
% segmentation of the background, horizontally and vertically textured
% fibers for every slice of the 3D dataset.
% additionally, a segmentation of the merged fibers is also returned
function [L_S,H_S,V_S,F_S] = segment_fibers_3D(img, n_train_img, img_features, selections, ...
                                               filter_l,filter_h,filter_v, bg)

n_features = size(img_features,3);
n_classes = size(selections,3);

% estimate kernel smoothing functions: XY_ksd_f expresses the probability
% that feature outcome X of a pixel corresponds to pixel class Y
% disp('computing kernel smoothing functions ...');
[ksd_fs, ksd_xs] = estimate_ksds(img_features, selections);

imgt = img(:,:,n_train_img);

% extract features
% disp('extracting features ...');
imgt_features = zeros(size(imgt,1),size(imgt,2),n_features);
imgt_features(:,:,1) = imfilter(imgt,filter_l);        % lowpass filter
imgt_features(:,:,2) = imfilter(imgt,filter_h);        % horizontal high-pass filter
imgt_features(:,:,3) = imfilter(imgt,filter_v);        % vertical high-pass filter
imgt_features(:,:,4) = stdfilt(imgt_features(:,:,2));  % local standard deviation of horizontal high-pass filter
imgt_features(:,:,5) = stdfilt(imgt_features(:,:,3));  % local standard deviation of vertical high-pass filter

% compute probability maps
% disp('computing probability maps ...');
pms = compute_pms(imgt_features, ksd_xs, ksd_fs);

% combine probability maps to class probability maps
% disp('combining probability maps to class probability maps ...');
init_params = ones(n_features,n_classes)/n_features;
init_params(:,1) = [0.88 0.01 0.01 0.05 0.05];
init_params(:,2) = [0.40 0.00 0.30 0.00 0.30];
init_params(:,3) = [0.40 0.30 0.00 0.30 0.00];
f = select_optimal_params(init_params,pms);
waitfor(f);
load temp.mat;
params = good_params;
clear good_params;

class_pms = zeros(size(pms,1),size(pms,2),n_classes);
for nc=1:n_classes
    for nf=1:n_features
        class_pms(:,:,nc) = class_pms(:,:,nc) + params(nf,nc).*pms(:,:,nf,nc);
    end
end

% process all the 2D slices
L_S = zeros(size(img));
H_S = zeros(size(img));
V_S = zeros(size(img));
F_S = zeros(size(img));
h = waitbar(0,'Processing 2D slices ...');
for ns=1:size(img,3)
    [L,H,V,F] = process_2D(img(:,:,ns),class_pms,filter_l,filter_h,filter_v,bg);
    L_S(:,:,ns) = L;
    H_S(:,:,ns) = H;
    V_S(:,:,ns) = V;
    F_S(:,:,ns) = F;
    waitbar(ns/size(img,3));
end
close(h);

end

function [L,H,V,F] = process_2D(img,filter_l,filter_h,filter_v,bg)
    % extract features
    % disp('extracting features ...');
    img_features = zeros(size(img,1),size(img,2),n_features);
    img_features(:,:,1) = imfilter(img,filter_l);        % lowpass filter
    img_features(:,:,2) = imfilter(img,filter_h);        % horizontal high-pass filter
    img_features(:,:,3) = imfilter(img,filter_v);        % vertical high-pass filter
    img_features(:,:,4) = stdfilt(img_features(:,:,2));  % local standard deviation of horizontal high-pass filter
    img_features(:,:,5) = stdfilt(img_features(:,:,3));  % local standard deviation of vertical high-pass filter

    % compute probability maps
    % disp('computing probability maps ...');
    pms = compute_pms(img_features, ksd_xs, ksd_fs);
    
    % combine probability maps to class probability maps
    % disp('combining probability maps to class probability maps ...');
    class_pms = zeros(size(pms,1),size(pms,2),n_classes);
    for nc=1:n_classes
        for nf=1:n_features
            class_pms(:,:,nc) = class_pms(:,:,nc) + params(nf,nc).*pms(:,:,nf,nc);
        end
    end
    
    % extract segmentation from class probability maps
    % disp('extracting segmentation from class probability maps ...');
    [~,I_S] = max(class_pms,[],3);
    L = I_S==1;
    H = I_S==2;
    V = I_S==3;
    
    % clean segmentation
    % disp('cleaning segmentation ...');
    LL = medfilt2(L,[11 11]);
    LLL = imclose(LL,strel('disk',3));
    LLLL = imopen(LLL,strel('disk',6));
    LLLLL = imfill(LLLL,'holes');
    LLLLLL = bwareaopen(LLLLL, 1000);

    HH = medfilt2(H,[11 11]);
    HHH = imclose(HH,strel('disk',13));
    HHHH = imopen(HHH,strel('disk',5));
    HHHHH = imfill(HHHH,'holes');
    HHHHHH = bwareaopen(HHHHH, 2500);

    VV = medfilt2(V,[11 11]);
    VVV = imclose(VV,strel('disk',13));
    VVVV = imopen(VVV,strel('disk',5));
    VVVVV = imfill(VVVV,'holes');
    VVVVVV = bwareaopen(VVVVV, 2500);

    % final segmentation
    L = LLLLLL;
    H = HHHHHH;
    V = VVVVVV;

    F = max(min(H+V,1)-L-bg,0);
    
end