
clear all
close all

dir = '/net/IPI/scratch/hluong/UTC/';
filename1 = 'pre li 261 nr3 goed';
filename2 = 'pre re 261 nr2';

image_good = permute(read_utc(dir,filename1),[1,3,2]);
image_bad = permute(read_utc(dir,filename2),[1,3,2]);

implay(image_good);
implay(image_bad);

im_diff = abs(double(image_good)-double(image_bad));
im_diff = uint8(im_diff/max(im_diff(:))*255);
implay(im_diff);

% [Gx_g,Gy_g,Gz_g] = gradient(double(image_good));
% [Gx_b,Gy_b,Gz_b] = gradient(double(image_good));
% 
% Gx_g = log(abs(Gx_g));
% Gx_g = uint8(Gx_g/max(Gx_g(:))*255);
% implay(Gx_g);
% 
% Gy_g = log(abs(Gy_g));
% Gy_g = uint8(Gy_g/max(Gy_g(:))*255);
% implay(Gy_g);
% 
% Gz_g = log(abs(Gz_g));
% Gz_g = uint8(Gz_g/max(Gz_g(:))*255);
% implay(Gz_g);
% 
% Gx_b = log(abs(Gx_b));
% Gx_b = uint8(Gx_b/max(Gx_b(:))*255);
% implay(Gx_b);
% 
% Gy_b = log(abs(Gy_b));
% Gy_b = uint8(Gy_b/max(Gy_b(:))*255);
% implay(Gy_b);
% 
% Gz_b = log(abs(Gz_b));
% Gz_b = uint8(Gz_b/max(Gz_b(:))*255);
% implay(Gz_b);