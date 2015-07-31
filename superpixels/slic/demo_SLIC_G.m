%% Demo of the SLIC superpixel algorithm on a grayscale image

clear all;
close all;

%% Read image
img = double(imread('lena.tif'));

%% SLIC parameters
N = -1; % the number of superpixels, set this negative if you want 
          % to define this in terms of superpixel size
S = 256;  % superpixel size (if N is negative)
if N<0
    N = floor(size(img,1)*size(img,2)/S);
end
compactness = 40;
n_iter = 10;

%% SLIC algorithm
tic
labels = fSLIC_G(img,N,compactness,n_iter);
toc
boundary = labels2edges(labels);
labeled = fill_segments(img,labels);

%% Show superpixel segmentation
figure,imshow(uint8(mask(img,boundary)),[0,255]);
figure,imshow(labeled,[0,255]);
