function patches = get_patches(img,bw,half_patch_size)
    s = regionprops(bw,'centroid');
    centroids = cat(1, s.Centroid);
    patches = zeros(2*half_patch_size+1,2*half_patch_size+1,size(centroids,1));
    for i=1:size(centroids,1)
        patches(:,:,i) = img(centroids(i,2)-half_patch_size:centroids(i,2)+half_patch_size,...
                             centroids(i,1)-half_patch_size:centroids(i,1)+half_patch_size);
%         patches(:,:,i) = img(centroids(i,2)-half_patch_size:centroids(i,2)+half_patch_size,...
%                              centroids(i,1)-2*half_patch_size:centroids(i,1));
    end
end