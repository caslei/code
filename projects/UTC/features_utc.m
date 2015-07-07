clear all
close all

dir = '/net/IPI/scratch/hluong/UTC/';
filename1 = 'pre re 261 nr2';

I = permute(read_utc(dir,filename1),[1,3,2]);
% implay(I);
% N = 9;

% Xp_3d = zeros(size(I,1),size(I,2),24,size(I,3));
% Xp_3d = zeros(size(I,1),size(I,2),10,size(I,3));
% Xp_3d = zeros(size(I,1),size(I,2),10,size(I,3));
h = waitbar(0,'Please wait...');
for i=1:size(I,3)
    % Xp_3d(:,:,:,i) = GaborFeatures(I(:,:,i));
    % Xp_3d(:,:,:,i) = LawsOperators(I(:,:,i));
    % Xp_3d(:,:,:,i) = PowerSpectrum(I(:,:,i));
    waitbar(i/size(I,3));
end
close(h)

% implay(I);
implay(Xp_3d(:,:,1,:));