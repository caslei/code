
clear all;
close all;

%% Read image
img = double(imread('lena.tif'));

%% TP parameters
N = -1; % the number of superpixels, set this negative if you want 
          % to define this in terms of superpixel size
S = 256;  % superpixel size (if N is negative)
if N<0
    N = floor(size(img,1)*size(img,2)/S);
end

tic
boundary = fTP(img, N);
noise_label_edges = double(boundary);
noise_label_edges_inv_logical = logical(1-noise_label_edges);
noise_label_edges_labeled = bwlabel(noise_label_edges_inv_logical,4);
se = strel('disk',2);
SegLabel = imdilate(noise_label_edges_labeled,se);

labeled = zeros(size(SegLabel));
for j=min(SegLabel(:)):max(SegLabel(:))
    avg_pixels = mean2(I(SegLabel==j));
    labeled(SegLabel==j) = avg_pixels;
end
figure;
imshow(labeled,[0,255]);
disp(['The computation took ' num2str(toc) ' seconds on the ' num2str(size(I,1)) 'x' num2str(size(I,2)) ' image']);

figure;clf
bw = edge(SegLabel,0.01);
J1=showmask(I(:,:,1),imdilate(bw,ones(2,2))); imshow(J1,[0,255]);axis off
disp('This is the segmentation.');