clear all
close all

dir = '/net/IPI/scratch/hluong/UTC/';
filename = 'pre li 261 nr3 goed';

image = read_utc(dir,filename);

figure, imshow(image(:,:,1));