% demo_slic
% 
% demo for slic

disp('SLIC superpixels demo');

%% read image, change color image to brightness image
I = imread_preprocess('em2_512.tif',512,512);

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

I = normalize(I);
J = normalize(J);

%% display the images
figure(1);clf; imagesc(I);colormap(gray);axis off;
disp('This is the input image to segment');
figure(2);clf; imagesc(J);colormap(gray);axis off;
disp('This is the denoised input image to segment');

I_3D = zeros(size(I,1),size(I,2),3);
J_3D = I_3D;
I_3D(:,:,1) = I;
I_3D(:,:,2) = I;
I_3D(:,:,3) = I;
J_3D(:,:,1) = J;
J_3D(:,:,2) = J;
J_3D(:,:,3) = J;
I = I_3D;
J = J_3D;
clear I_3D; clear J_3D;

%% compute superpixels
sigma = 1.5;
k = 200;
min = 20;
colopt = 'median';
% nbSegments = 250; % oversegmentation
disp('computing graph based superpixels ...');
tic;
% [SegLabel, C1, d] = slic(I, nbSegments, m);
SegLabel = graph_based(I, sigma, k, min);
disp(['The computation took ' num2str(toc) ' seconds on the ' num2str(size(I,1)) 'x' num2str(size(I,2)) ' image']);

%% display the segmentation
figure(3);clf
bw = edge(SegLabel);
J1=showmask(I(:,:,1),imdilate(bw,ones(2,2))); imagesc(J1);axis off
disp('This is the segmentation.');
% pause;

%% compute superpixels
disp('computing denoised graph based superpixels ...');
tic;
% [SegLabel, C2, d] = slic(J, nbSegments, m);
SegLabel = graph_based(J, sigma, k, min);
disp(['The computation took ' num2str(toc) ' seconds on the ' num2str(size(J,1)) 'x' num2str(size(J,2)) ' image']);

%% display the denoised segmentation
figure(4);clf
bw = edge(SegLabel);
J1=showmask(J(:,:,1),imdilate(bw,ones(2,2))); imagesc(J1);axis off
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