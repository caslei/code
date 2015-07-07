
close all;
clear all;

patch_size = 200;
% ref_row = 600; % Vertical edge
% ref_col = 4250;
ref_row = 3980; % Horizontal edge
ref_col = 4200;

chars = 'abcdefgh';
n_patches_image = 400;
n_patches = numel(chars)*n_patches_image;
disp(strcat('Estimated noise reduction factor: ', num2str(sqrt(n_patches))));

step_row = 10;
step_col = 10;

patches = zeros(patch_size, patch_size, n_patches); 

m = 1;
for m=1:8
    
    I = imreadDM3(strcat('/ipi/shared/biology/dmbr/thesisData/grid-blur/dwell times optimal grid/dwell0_5_',chars(m),'.dm3'));
    J = normalise(double(I));
    [M, N] = size(J);
    ref_patch = J(ref_row+1:ref_row+patch_size,ref_col+1:ref_col+patch_size);

    std_orig = std2(ref_patch(20:60,20:60));

    similarities = zeros(size(I,1), size(I,2));
    for row=1:step_row:(M-patch_size+1)
        disp(strcat('Image_', chars(m), ': ', num2str(row/(M-patch_size+1))));
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
std_red = std2(average_patch(20:60,20:60));

figure;
imshow(average_patch, [0 2^8-1]); colormap(gray); title(strcat('Original noise std: ',num2str(std_orig), ', ',...
                                                               'Reduced noise std: ',num2str(std_red), ', ',...
                                                               'Noise reduction factor: ', num2str(sqrt(n_patches))));
