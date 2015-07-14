function sel_patches = select_patches(patches,ref_patch)
    T = 2.5;
    sel_patches = [];
    ind = 1;
    for i=1:size(patches,3)
        if (MSE(patches(:,:,i),ref_patch)/numel(ref_patch)) < T
            sel_patches(:,:,ind) = patches(:,:,i);
            ind = ind+1;
        end
    end
end