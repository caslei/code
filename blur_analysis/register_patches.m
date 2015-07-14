function reg_patches = register_patches(patches,ref_patch)
    reg_patches = zeros(size(patches));
    [optimizer, metric] = imregconfig('multimodal');
    for i=1:size(patches,3)
        reg_patches(:,:,i) = imregister(patches(:,:,i),ref_patch,'translation',optimizer,metric);
        % disp(num2str(i/size(patches,3)));
    end
end