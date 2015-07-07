
close all;
clear all;

patch_size = 300;
ref_row = 2290; 
ref_col = 1620;

n_patches_image = 40;
num_images = 15;
n_patches = num_images*n_patches_image;
disp(strcat('Estimated noise reduction factor: ', num2str(sqrt(n_patches))));

I = imreadDM3(strcat('/ipi/shared/biology/dmbr/thesisData/grid-blur/grid manual/image1.dm3'));
ref_tpatch = I(ref_row+1:ref_row+3*patch_size,ref_col+1:ref_col+3*patch_size);
[optimizer, metric] = imregconfig('Multimodal');

step_row = 5;
step_col = 5;

patches = zeros(patch_size, patch_size, n_patches); 

% m = 15;
for m=1:num_images
    
    I = imreadDM3(strcat('/ipi/shared/biology/dmbr/thesisData/grid-blur/grid manual/image',num2str(m),'.dm3'));
    [M, N] = size(I);
    
    tpatch = I(ref_row+1:ref_row+3*patch_size,ref_col+1:ref_col+3*patch_size);
    tform = imregtform(ref_tpatch, tpatch, 'translation', optimizer, metric);
    x_t = round(tform.T(3,1));
    y_t = round(tform.T(3,2));
    
    J = normalise(double(I));
    ref_patch = J(ref_row+y_t+1:ref_row+y_t+patch_size,ref_col+x_t+1:ref_col+x_t+patch_size);

    similarities = zeros(size(I,1), size(I,2));
    for row=1:step_row:(M-patch_size+1)
        disp(strcat('Image_', num2str(m), ': ', num2str(row/(M-patch_size+1))));
        for col=1:step_col:(N-patch_size+1)
            patch = J(row:row+patch_size-1, col:col+patch_size-1);
            s = sum(sum((patch-ref_patch).^2));
            similarities(row, col) = s;
        end
    end
    
    similarities(similarities==0) = Inf;
    similarities = similarities(:);
    [~,indices] = sort(similarities);
    patch_indices = indices(1:n_patches_image);
    [patch_rows, patch_cols] = index_to_rowcol(patch_indices, M, N);
    for i=1:n_patches_image
        patch_row = patch_rows(i);
        patch_col = patch_cols(i);
        j = (m-1)*n_patches_image+i;
        patches(:,:,j) = J(patch_row:patch_row+patch_size-1, patch_col:patch_col+patch_size-1);
    end
    
end

average_patch = sum(patches,3)/n_patches;

figure;
imshow(average_patch, []); colormap(gray); title(strcat('Noise reduction factor: ', num2str(sqrt(n_patches))));
