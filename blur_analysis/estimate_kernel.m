
clear all;
close all;

N = 75;
crop = 100;
half_patch_size = 500;
mean_patches = zeros(2*half_patch_size-2*crop+1,2*half_patch_size-2*crop+1,N);

for i=1:N
    
    % read image
    img = read_img(i);

    % convert to black-white image
    bw = thresh_and_clean(img);

    % get patches corresponding to crosses
    patches = get_patches(img,bw,half_patch_size);
    if i==1
        ref_patch = patches(:,:,3);
    end

    % register patches
    reg_patches = register_patches(patches,ref_patch);
    reg_patches_cropped = reg_patches(crop+1:end-crop,crop+1:end-crop,:);

    % select similar patches
    selected_patches = select_patches(reg_patches_cropped,ref_patch(crop+1:end-crop,crop+1:end-crop));

    % average out patches
    mean_patches(:,:,i) = sum(selected_patches,3)/size(selected_patches,3);

    disp(num2str(i/N));
    
end

save('mean_patches.mat','mean_patches');
mean_patch = sum(mean_patches,3)/N;

figure,imshow(mean_patch,[]);
