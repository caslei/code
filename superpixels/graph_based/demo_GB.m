%% Demo of the graph based superpixel algorithm

clear all;
close all;

%% Read image
img = double(imread('lena.tif'));

%% GB parameters
sigma = 0.5;
k = 500;
min = 20;

%% GB algorithm
tic
labels = fGB(img,N,sigma,k,min);
toc
boundary = labels2edges(labels);
labeled = fill_segments(img,labels);

%% Show superpixel segmentation
figure,imshow(mask(img,boundary),[0,255]);
figure,imshow(labeled,[0,255]);
