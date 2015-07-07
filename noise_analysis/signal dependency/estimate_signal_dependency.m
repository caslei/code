
clear all;
close all;

img_name = 'em1_512.tif';
half_patch_size = 15;
num_levels = 32;
step = 25;

img = imread(img_name);
[rows,cols] = size(img);

i=1;
for r=1+half_patch_size:step:rows-half_patch_size
    r
    for c=1+half_patch_size:step:cols-half_patch_size
        patch = img(r-half_patch_size:r+half_patch_size,c-half_patch_size:c+half_patch_size);
        features{i} = haralick_features(patch,num_levels);
        features{i}.row = r;
        features{i}.col = c;
        i = i+1;
    end
end

[patch_coos,values] = classify_constant_intensity(features);
plot(values);

patches = process_patches(img, patch_coos, half_patch_size);