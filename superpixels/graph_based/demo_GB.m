%% Demo of the graph based superpixel algorithm

clear all;
close all;

%% Read image
img = double(imread('lena.tif'));

%% GB parameters
sigma = 0.5;
k = 100;
min = 20;

%% GB algorithm
tic
labels = fGB(img,sigma,k,min);
toc
boundary = labels2edges(labels);
labeled = fill_segments(img,labels);

%% Show superpixel segmentation
figure,imshow(uint8(mask(img,boundary)),[0,255]);
figure,imshow(uint8(labeled),[0,255]);
