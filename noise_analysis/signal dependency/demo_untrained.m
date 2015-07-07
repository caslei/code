
im_path = '/ipi/shared/biology/dmbr/SBF-SEM/bio-imaging/plant-root/testrr_3VBSED_slice_0000.dm3';
[~,I] = dmread(im_path);

% imshow(I,[min(I(:)),max(I(:))])

patch_size = 50;

stds = [];
means = [];
for i=0:floor((size(I,1)-patch_size)/patch_size)
    i/floor((size(I,1)-patch_size)/patch_size)
    for j=0:floor((size(I,2)-patch_size)/patch_size)
        patch = I(i*patch_size+1:(i+1)*patch_size,j*patch_size+1:(j+1)*patch_size);
        % imshow(patch,[min(patch(:)),max(patch(:))])
        stds = [stds, std2(patch)];
        means = [means, mean2(patch)];
    end
end

% figure; plot(stds)
% figure; hist(means,500)

std_thresh = 2000;
stds_threshed = stds(stds<std_thresh);
means_threshed = means(stds<std_thresh);

% scatter(means_threshed,stds_threshed)

int_min = 19400;
int_max = 22000;
inc = 100;
means_avg = [];
stds_avg = [];
for int=int_min:int_max
    int_m = int-inc/2;
    int_M = int+inc/2;
    mean_avg = mean(means_threshed(logical((means_threshed>int_m).*(means_threshed<int_M))));
    std_avg = mean(stds_threshed(logical((means_threshed>int_m).*(means_threshed<int_M))));
    means_avg = [means_avg, mean_avg];
    stds_avg = [stds_avg, std_avg];
end

scatter(means_avg, stds_avg);