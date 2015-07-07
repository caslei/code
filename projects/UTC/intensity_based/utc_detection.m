
% % clear all
% % close all
% 
% dir = '/net/IPI/scratch/hluong/UTC/';
% filename1 = 'pre re 261 nr2';
% 
% I = permute(read_utc(dir,filename1),[1,3,2]);
% % implay(I);
% 
img = I(:,:,179);
% figure; imshow(img);

% Parameters
alfa1_d = 0.7;
alfa2_d = 0.8;
thr_d = 0.4;
offset = 0.15;
alfa1_begin = alfa1_d-offset;
alfa1_inc = 0.05;
alfa1_end = alfa1_d+offset;
thr_begin = thr_d-offset;
thr_inc = 0.05;
thr_end = thr_d+offset;
str_thr = 0;
overlap_thr = 0;
min_comp_size = 10;
combined_uthr = 12;
combined_lthr = 7;

% Generate lots of edges (and a lot of garbage) by switching alfa1
% parameter
uni_mask = zeros(size(img));
for alfa1=alfa1_begin:alfa1_inc:alfa1_end
    mask = horizontal_edge_detector(img, alfa1, alfa2_d, thr_d);
    uni_mask = uni_mask+mask;
end
uni_mask = logical(uni_mask);

% figure,imshow(drawmask(img,uni_mask)./255);
% title('UNI MASK');
% figure; imagesc(uni_mask); colormap gray;

% Detect real edge parts by switching thr parameter
int_mask = ones(size(img));
for thr=thr_begin:thr_inc:thr_end
    mask = horizontal_edge_detector(img, alfa1_d, alfa2_d, thr);
    int_mask = int_mask.*mask;
end
int_mask = logical(int_mask);

% figure,imshow(drawmask(img,int_mask)./255);
% title('INT MASK');
% figure; imagesc(int_mask); colormap gray;

% Merge close components
se_c = strel('disk',5);
uni_mask = imclose(uni_mask,se_c);
% figure; imagesc(uni_mask); colormap gray;
uni_mask = bwmorph(uni_mask,'thin',Inf);
% figure; imagesc(uni_mask); colormap gray;
CC_uni = bwconncomp(uni_mask);
n_cc_uni = CC_uni.NumObjects;
for n=1:n_cc_uni
    comp_ns = CC_uni.PixelIdxList{n};
    if numel(comp_ns)<min_comp_size
        uni_mask(comp_ns) = 0;
    end
end
% figure; imagesc(uni_mask); colormap gray;

int_mask = imclose(int_mask,se_c);
% figure; imagesc(int_mask); colormap gray;
int_mask = bwmorph(int_mask,'skel',Inf);
% figure; imagesc(int_mask); colormap gray;
CC_int = bwconncomp(int_mask);
n_cc_uni = CC_int.NumObjects;
for n=1:n_cc_uni
    comp_ns = CC_int.PixelIdxList{n};
    if numel(comp_ns)<min_comp_size
        int_mask(comp_ns) = 0;
    end
end
% figure; imagesc(int_mask); colormap gray;

% Select components corresponding to real edges, using partial map
CC_uni = bwconncomp(uni_mask);
n_cc_uni = CC_uni.NumObjects;
temp_mask_str = zeros(size(img));
temp_mask_overlap = zeros(size(img));
for n=1:n_cc_uni
    comp_ns = CC_uni.PixelIdxList{n};
    str = sum(uni_mask(comp_ns));
    if str > str_thr % if component is active in most masks (to a certain degree)
        overlap = sum(int_mask(comp_ns));
        if overlap > overlap_thr % if component overlaps with intersected mask (to a certain degree)
            temp_mask_str(comp_ns) = str;
            temp_mask_overlap(comp_ns) = overlap;
        end
    end
end
temp_mask_str = log(temp_mask_str);
temp_mask_overlap = log(temp_mask_overlap);
temp_mask_combined = temp_mask_str + temp_mask_overlap;
% figure; imagesc(temp_mask_combined); colormap gray;

mask = logical((temp_mask_combined < combined_uthr) .* (temp_mask_combined > combined_lthr));
figure,imshow(drawmask(img,mask)./255);

[Gx, Gy] = imgradientxy(mask,'IntermediateDifference');
figure; imagesc(Gy);