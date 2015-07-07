
clear all;
close all;

img_name = 'em1_512.tif';
half_patch_size = 15;
num_levels = 32;

img = imread(img_name);

imshow(img,[]);

[x,y] = getpts;
x = round(x);
y = round(y);

N = numel(x);
features = cell(N,1);
for i=1:N
    patch = img(y(i)-half_patch_size:y(i)+half_patch_size,x(i)-half_patch_size:x(i)+half_patch_size);
    features{i} = haralick_features(patch,num_levels);
    features{i}.row = y(i);
    features{i}.col = x(i);
end

[patches,values] = classify_constant_intensity(features);
plot(values);
