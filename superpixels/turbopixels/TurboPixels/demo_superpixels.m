
% addpath('lsmlib');
clear all;close all;

I = double(imread('lena.tif'));
I_3D = zeros(size(I,1),size(I,2),3);
I_3D(:,:,1) = I;
I_3D(:,:,2) = I;
I_3D(:,:,3) = I;
img = I_3D;
clear I_3D; 

n_superpixels = 1000;
tic
[phi,boundary,disp_img] = turbopixels(img, n_superpixels);
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
imagesc(labeled);colormap gray;axis off
disp(['The computation took ' num2str(toc) ' seconds on the ' num2str(size(I,1)) 'x' num2str(size(I,2)) ' image']);

figure;clf
bw = edge(SegLabel,0.01);
J1=showmask(I(:,:,1),imdilate(bw,ones(2,2))); imagesc(J1);axis off
disp('This is the segmentation.');


imwrite(uint8(labeled),'tp-avg.png');
imwrite(J1,'tp-bnd.png');