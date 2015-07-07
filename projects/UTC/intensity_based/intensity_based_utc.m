% clear all
% close all

% dir = '/net/IPI/scratch/hluong/UTC/';
% filename1 = 'pre re 261 nr2';

% I = permute(read_utc(dir,filename1),[1,3,2]);
% implay(I);

% img = I(:,:,180);
% imshow(img);

% alfa1 = 0.7; 
% alfa2 = 0.8; 
% thr = 0.4;
% mask = edge_detector(img, alfa1, alfa2, thr);
% figure,imshow(drawmask(img,mask)./255);
% title('EDGE DETECTOR');
% 
% alfa = 0.8; 
% thr = 0.6;
% mask = line_detector(img, alfa, thr);
% figure,imshow(drawmask(img,mask)./255);
% title('LINE DETECTOR');
% 
% alfa1 = 0.9; 
% alfa2 = 0.8; 
% thr = 0.4;
% mask = vertical_edge_detector(img, alfa1, alfa2, thr);
% figure,imshow(drawmask(img,mask)./255);
% title('VERTICAL EDGE DETECTOR');
% 
% alfa = 0.95; 
% thr = 0.5;
% mask = vertical_line_detector(img, alfa, thr);
% figure,imshow(drawmask(img,mask)./255);
% title('VERTICAL LINE DETECTOR');


alfa1 = 0.7; 
alfa2 = 0.9; 
thr = 0.4;
mask = horizontal_edge_detector(img, alfa1, alfa2, thr);
figure,imshow(drawmask(img,mask)./255);
title(['HORIZONTAL EDGE DETECTOR alfa1=' num2str(alfa1) ', alfa2=' num2str(alfa2) ', thr=' num2str(thr)]);


% alfa = 0.95; 
% thr = 0.5;
% mask = horizontal_line_detector(img, alfa, thr);
% figure,imshow(drawmask(img,mask)./255);
% title('HORIZONTAL LINE DETECTOR');
