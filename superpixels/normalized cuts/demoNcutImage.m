% demoNcutImage
% 
% demo for NcutImage
% also initialize matlab paths to subfolders
% Timothee Cour, Stella Yu, Jianbo Shi, 2004.

disp('Ncut Image Segmentation demo');

%% read image, change color image to brightness image, resize to 160x160
% I = imread_ncut('jpg_images/3.jpg',160,160);
I = imread_ncut('em1_256.tif',256,256);

%% display the image
figure(1);clf; imagesc(I);colormap(gray);axis off;
disp('This is the input image to segment, press Enter to continue...');
pause;

%% Denoise image
sigma = 20; % 
alpha = 1; 
sigma_0 = sigma;
W = 3;
h = 6;
T = 0.7;
wnd_size = 5;
weighting_function_name = 'MODIFIED_BISQUARE'; 
V = 0; 
[noise, PS] = emnoise(I, alpha, sigma_0^2);
[J, ~, ~] = fNLMS_SC(I, I, h, T, PS, alpha, sigma_0^2, W, wnd_size, weighting_function_name, V);
figure(2);clf; imagesc(J);colormap(gray);axis off;
disp('This is the denoised input image to segment, press Enter to continue...');
pause;

%% compute the edges imageEdges, the similarity matrix W based on
%% Intervening Contours, the Ncut eigenvectors and discrete segmentation
nbSegments = 250;
% nbSegments = 250; % oversegmentation
disp('computing Ncut eigenvectors ...');
tic;
[SegLabel,NcutDiscrete,NcutEigenvectors,NcutEigenvalues,W,imageEdges]= NcutImage(I,nbSegments);
disp(['The computation took ' num2str(toc) ' seconds on the ' num2str(size(I,1)) 'x' num2str(size(I,2)) ' image']);


%% display the edges
% figure(2);clf; imagesc(imageEdges); axis off
% disp('This is the edges computed, press Enter to continue...');
% pause;

%% display the segmentation
figure(3);clf
bw = edge(SegLabel,0.01);
J1=showmask(I,imdilate(bw,ones(2,2))); imagesc(J1);axis off
disp('This is the segmentation.');
% pause;

%% compute the edges imageEdges, the similarity matrix W based on
%% Intervening Contours, the Ncut eigenvectors and discrete segmentation
disp('computing denoised Ncut eigenvectors ...');
tic;
[SegLabel,NcutDiscrete,NcutEigenvectors,NcutEigenvalues,W,imageEdges]= NcutImage(J,nbSegments);
disp(['The computation took ' num2str(toc) ' seconds on the denoised ' num2str(size(J,1)) 'x' num2str(size(J,2)) ' image']);

%% display the denoised segmentation
figure(4);clf
bw = edge(SegLabel,0.01);
J1=showmask(J,imdilate(bw,ones(2,2))); imagesc(J1);axis off
disp('This is the denoised segmentation.');
% pause;

%% display Ncut eigenvectors
% figure(4);clf;set(gcf,'Position',[100,500,200*(nbSegments+1),200]);
% [nr,nc,nb] = size(I);
% for i=1:nbSegments
%     subplot(1,nbSegments,i);
%     imagesc(reshape(NcutEigenvectors(:,i) , nr,nc));axis('image');axis off;
% end
% disp('This is the Ncut eigenvectors...');
disp('The demo is finished.');

