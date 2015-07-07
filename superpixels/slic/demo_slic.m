% demo_slic
% 
% demo for slic
clear all; close all;
disp('SLIC superpixels demo');

%% read image, change color image to brightness image
J = double(imread('lena.tif'));
I = zeros(size(J,1),size(J,2),3);
I(:,:,1) = J;
I(:,:,2) = J;
I(:,:,3) = J;

%% display the images
figure(1);clf; imshow(uint8(I));axis off;
disp('This is the input image to segment');

%% compute superpixels
nbSegments = 1000;
m = 20;
disp('computing slic superpixels ...');
tic;
[SegLabel, C1, d] = slic(I, nbSegments, m);
labeled = zeros(size(SegLabel));
for j=min(SegLabel(:)):max(SegLabel(:))
    avg_pixels = mean2(I(SegLabel==j));
    labeled(SegLabel==j) = avg_pixels;
end
figure;
imshow(uint8(labeled));colormap gray;axis off
disp(['The computation took ' num2str(toc) ' seconds on the ' num2str(size(I,1)) 'x' num2str(size(I,2)) ' image']);

%% display the segmentation
figure(3);clf
bw = edge(SegLabel,0.01);
J1=showmask(I(:,:,1),imdilate(bw,ones(2,2))); imshow(J1);axis off
disp('This is the segmentation.');
% pause;

imwrite(uint8(labeled),'slic-avg.png');
imwrite(J1,'slic-bnd.png');

% %% compute superpixels
% disp('computing denoised slic superpixels ...');
% tic;
% [SegLabel, C2, d] = slic(J, nbSegments, m);
% disp(['The computation took ' num2str(toc) ' seconds on the ' num2str(size(J,1)) 'x' num2str(size(J,2)) ' image']);
% 
% %% display the denoised segmentation
% figure(4);clf
% bw = edge(SegLabel,0.01);
% J1=showmask(J(:,:,1),imdilate(bw,ones(2,2))); imagesc(J1);axis off
% disp('This is the denoised segmentation.');
% % pause;

%% display Ncut eigenvectors
% figure(4);clf;set(gcf,'Position',[100,500,200*(nbSegments+1),200]);
% [nr,nc,nb] = size(I);
% for i=1:nbSegments
%     subplot(1,nbSegments,i);
%     imagesc(reshape(NcutEigenvectors(:,i) , nr,nc));axis('image');axis off;
% end
% disp('This is the Ncut eigenvectors...');
disp('The demo is finished.');