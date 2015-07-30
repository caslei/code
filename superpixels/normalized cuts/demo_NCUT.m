%% Demo of the normalized cuts superpixel algorithm

clear all;
close all;

%% Read image
img = double(imread('lena.tif'));

%% NCUT parameters
N = -1; % the number of superpixels, set this negative if you want 
          % to define this in terms of superpixel size
S = 256;  % superpixel size (if N is negative)
if N<0
    N = floor(size(img,1)*size(img,2)/S);
end
compactness = 20; % compactness parameter
n_iter = 10;      % number of iterations 

%% NCUT algorithm
tic
labels = fNCUT(img,N);
toc
boundary = labels2edges(labels);
labeled = fill_segments(img,labels);

%% Show superpixel segmentation
figure,imshow(mask(img,boundary),[0,255]);
figure,imshow(labeled,[0,255]);

