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
disp('computing kernel smoothing functions ...');
[ksd_fs, ksd_xs] = estimate_ksds(img_features, selections);

% figure;
% for nc = 1:n_classes
%     for nf = 1:n_features
%         subplot(n_classes,n_features,(nf-1)*n_classes+nc)
%         plot(ksd_xs{nf,nc},ksd_fs{nf,nc});
%     end
% end

% extract features
disp('extracting features ...');
imgt_features = zeros(size(img,1),size(img,2),n_features);
imgt_features(:,:,1) = imfilter(img,filter_l);        % lowpass filter
imgt_features(:,:,2) = imfilter(img,filter_h);        % horizontal high-pass filter
imgt_features(:,:,3) = imfilter(img,filter_v);        % vertical high-pass filter
imgt_features(:,:,4) = stdfilt(imgt_features(:,:,2)); % local standard deviation of horizontal high-pass filter
imgt_features(:,:,5) = stdfilt(imgt_features(:,:,3)); % local standard deviation of vertical high-pass filter

% compute probability maps
disp('computing probability maps ...');
pms = compute_pms(imgt_features, ksd_xs, ksd_fs);

% figure;
% for nc = 1:n_classes
%     for nf = 1:n_features
%         subplot(n_classes,n_features,(nf-1)*n_classes+nc)
%         imshow(pms{nf,nc},[]); 
%     end
% end

% combine probability maps to class probability maps
disp('combining probability maps to class probability maps ...');
params = zeros(n_features,n_classes);
params(:,1) = [1.00 0.05 0.05 0.25 0.25];
params(:,2) = [0.50 0.00 0.35 0.00 0.35];
params(:,3) = [0.50 0.35 0.00 0.35 0.00];

class_pms = zeros(size(pms,1),size(pms,2),n_classes);
for nc=1:n_classes
    for nf=1:n_features
        class_pms(:,:,nc) = class_pms(:,:,nc) + params(nf,nc).*pms(:,:,nf,nc);
    end
end

% figure, imshow(class_pms(:,:,1),[]);
% figure, imshow(class_pms(:,:,2),[]);
% figure, imshow(class_pms(:,:,3),[]);

% extract segmentation from class probability maps
disp('extracting segmentation from class probability maps ...');
[~,I_S] = max(class_pms,[],3);
L = I_S==1;
H = I_S==2;
V = I_S==3;

% figure,imshow(L,[]);
% figure,imshow(H,[]);
% figure,imshow(V,[]);

disp('cleaning segmentation ...');
LL = medfilt2(L,[11 11]);
LLL = imclose(LL,strel('disk',3));
LLLL = imopen(LLL,strel('disk',6));
LLLLL = imfill(LLLL,'holes');
LLLLLL = bwareaopen(LLLLL, 1000);
% figure,imshow(L,[]);
% figure,imshow(LL,[]);
% figure,imshow(LLL,[]);
% figure,imshow(LLLL,[]);
% figure,imshow(LLLLL,[]);
% figure,imshow(LLLLLL,[]);

HH = medfilt2(H,[11 11]);
HHH = imclose(HH,strel('disk',13));
HHHH = imopen(HHH,strel('disk',5));
HHHHH = imfill(HHHH,'holes');
HHHHHH = bwareaopen(HHHHH, 2500);
% figure,imshow(H,[]);
% figure,imshow(HH,[]);
% figure,imshow(HHH,[]);
% figure,imshow(HHHH,[]);
% figure,imshow(HHHHH,[]);
% figure,imshow(HHHHHH,[]);

VV = medfilt2(V,[11 11]);
VVV = imclose(VV,strel('disk',13));
VVVV = imopen(VVV,strel('disk',5));
VVVVV = imfill(VVVV,'holes');
VVVVVV = bwareaopen(VVVVV, 2500);
% figure,imshow(V,[]);
% figure,imshow(VV,[]);
% figure,imshow(VVV,[]);
% figure,imshow(VVVV,[]);
% figure,imshow(VVVVV,[]);
% figure,imshow(VVVVVV,[]);

% final segmentation
L_S = LLLLLL;
H_S = HHHHHH;
V_S = VVVVVV;

% figure, imshow(uint16(drawmask(im,H_S)));
% figure, imshow(uint16(im));
% figure, imshow(uint16(drawmask(im,V_S)));

F_S = max(min(H_S+V_S,1)-L_S-bg,0);

% figure, imshow(uint16(im));
% figure, imshow(uint16(drawmask(im,fibers)));


end