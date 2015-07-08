function cell_info = compute_centroids(r_chan, g_chan)

g_cc = bwconncomp(1-g_chan,4);
n = g_cc.NumObjects;

cell_info = struct;
cell_info.r_chan_filtered = zeros(size(r_chan));
cell_info.g_chan_filtered = zeros(size(g_chan));
cell_info.cell_centers = cell(1);
cell_info.kernel_centers = cell(1);
j = 1;
for i=1:n
    comp = zeros(size(g_chan));
    comp(g_cc.PixelIdxList{i}) = 1;
    intersection = logical(comp.*r_chan);
    r_cc = bwconncomp(intersection);
    if r_cc.NumObjects == 1
        cell_info.g_chan_filtered(logical(comp)) = 1;
        cell_info.r_chan_filtered(intersection) = 1;
        % geometric center cell
        temp_cell = regionprops(comp,'centroid');
        cell_info.cell_centers{j} = temp_cell(1).Centroid;
        % geometric center kernel
        temp_kernel = regionprops(intersection,'centroid');
        cell_info.kernel_centers{j} = temp_kernel(1).Centroid;
        j = j+1;
    end
end


end

