% demo_graph_based
% 
% demo for demo_graph_based
clear all;close all;
disp('Graph based superpixels demo');

%% read image, change color image to brightness image
I = imread('lena.tif');

%% display the images
figure(1);clf; imagesc(I);colormap(gray);axis off;
disp('This is the input image to segment');

I_3D = zeros(size(I,1),size(I,2),3);
I_3D(:,:,1) = I;
I_3D(:,:,2) = I;
I_3D(:,:,3) = I;
I = I_3D;
clear I_3D; 

%% compute superpixels
sigma = 0.5;
k = 70;
m = 20;
colopt = 'median';
disp('computing graph based superpixels ...');
tic;
% [SegLabel, C1, d] = slic(I, nbSegments, m);
SegLabel = double(graph_based(I, sigma, k, m))+1;
labeled = zeros(size(SegLabel));
for j=min(SegLabel(:)):max(SegLabel(:))
    avg_pixels = mean2(I(SegLabel==j));
    labeled(SegLabel==j) = avg_pixels;
end
figure;
imagesc(labeled);colormap gray;axis off
disp(['The computation took ' num2str(toc) ' seconds on the ' num2str(size(I,1)) 'x' num2str(size(I,2)) ' image']);

%% display the segmentation
figure(3);clf
bw = edge(SegLabel,0.01);
J1=showmask(I(:,:,1),imdilate(bw,ones(2,2))); imagesc(J1);axis off
disp('This is the segmentation.');
% pause;

imwrite(uint8(labeled),'gb-avg.png');
imwrite(J1,'gb-bnd.png');

%% display Ncut eigenvectors
% figure(4);clf;set(gcf,'Position',[100,500,200*(nbSegments+1),200]);
% [nr,nc,nb] = size(I);
% for i=1:nbSegments
%     subplot(1,nbSegments,i);
%     imagesc(reshape(NcutEigenvectors(:,i) , nr,nc));axis('image');axis off;
% end
% disp('This is the Ncut eigenvectors...');
disp('The demo is finished.');