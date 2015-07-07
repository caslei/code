function patches = process_patches(img, patch_coos, half_patch_size)

N = numel(patch_coos);
patches = zeros(2*half_patch_size+1,2*half_patch_size+1,N);

for i=1:N
    patches(:,:,i) = img(patch_coos{i}(1)-half_patch_size:patch_coos{i}(1)+half_patch_size,...
                         patch_coos{i}(2)-half_patch_size:patch_coos{i}(2)+half_patch_size);
end

end

