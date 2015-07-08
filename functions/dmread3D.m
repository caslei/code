
clear all;
close all;

dir_path = '/ipi/shared/biology/dmbr/data/2013_11_27_sample12_6_6_wt_aftercrash(8)/';
dest_path = '/net/ipi/scratch/jbroels/data/';
im_basename = 'arabidopsis_';

files = dir(dir_path);

j = 701;
for i=1:numel(files)
    file = files(i);
    if ~file.isdir
        [~, I] = dmread(strcat(dir_path,file.name));
        imwrite(I,strcat(dest_path,im_basename,num2str(j),'.tif'));
        j = j+1;
    end
end
