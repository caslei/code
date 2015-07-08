function [r_chan, g_chan] = thresh_and_clean_img(img, min_kernel_size)

img_r = img(:,:,1);
img_g = img(:,:,2);
[M,N] = size(img_r);

% thresholding
thr_g = 25;
thr_r = 75;
r_thr = logical((img_r > thr_r) .* (img_g <= thr_g));
g_thr = logical(img_g > thr_g);

% skeletonization
g_chan = bwmorph(g_thr,'thin',Inf);
g_chan = bwmorph(g_chan,'spur',Inf);
g_chan = bwmorph(g_chan,'clean');

% filter out small cell kernels
r_chan = zeros(M,N);
r_comps = bwconncomp(r_thr);
r_comps = r_comps.PixelIdxList;
for i=1:numel(r_comps)
    if numel(r_comps{i}) > min_kernel_size
        r_chan(r_comps{i}) = 1;
    end
end
r_chan = logical(r_chan);

end

