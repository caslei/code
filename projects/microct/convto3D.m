
clear all;
close all;

base_path = '/net/ipi/scratch/jbroels/microct/reconstructed2/1_';
ext = '.tif';

n0 = 159;
n = 1842;

img_3D = zeros(650,1300,1684);
for i=n0:n
    disp(num2str((i-n0+1)/1684))
    i_str = num2str(i);
    if i<1000
        i_str = ['0' i_str];
    end
    img = imread([base_path i_str '.tif']);
    img_3D(:,:,i-n0+1) = img;
end

outputFileName = '/net/ipi/scratch/jbroels/microct/reconstructed2/stack.tif';
imwrite3D(img_3D,outputFileName);