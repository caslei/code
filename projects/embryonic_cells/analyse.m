clear all;
close all;

im_path = '/net/ipi/scratch/jbroels/embryonic_cells/format 4 of F3.tif';
img = imread(im_path);
img = img(:,:,1:3);
% figure; imshow(img);

min_kernel_size = 50;
[r_chan, g_chan] = thresh_and_clean_img(img, min_kernel_size);
% figure, imshow(r_chan,[]);
% figure, imshow(g_chan,[]);

% stats = regionprops(r_chan,'Orientation','Area','Eccentricity');
% N = numel(stats);
% orients = zeros(1,N);
% areas = zeros(1,N);
% eccent = zeros(1,N);
% for i=1:N
%     orients(i) = mod(stats(i).Orientation,180);
%     areas(i) = stats(i).Area;
%     eccent(i) = stats(i).Eccentricity;
% end
% 
% figure, hist(orients, 50);
% title('Orientation distribution');
% figure, hist(areas, 50);
% title('Area distribution');
% figure, hist(eccent, 50);
% title('Eccentricity distribution');

% compute geometric cell and kernel centers
cell_info = compute_centroids(r_chan, g_chan);

dist = zeros(size(cell_info.cell_centers));
dir = zeros(size(cell_info.cell_centers));
for i=1:numel(dist)
    c_center = cell_info.cell_centers{i};
    k_center = cell_info.kernel_centers{i};
    dist(i) = sqrt(sum((c_center-k_center).^2));
    dir(i) = (180/pi)*atan2((k_center(2)-c_center(2)),(k_center(1)-c_center(1)));
end

figure; hist(dist,50);
title(['Mean: ' num2str(mean(dist)) ', Std: ' num2str(std(dist))]);
xlim([0,50]);
% figure; hist(dir,25);
% title(['Mean: ' num2str(mean(dir)) ', Std: ' num2str(std(dir))]);
% 
% img_show = zeros(size(img));
% img_show(:,:,1) = cell_info.r_chan_filtered;
% img_show(:,:,2) = cell_info.g_chan_filtered;
% figure; subplot('position', [0 0 1 1]);
% imagesc(img_show);
% [rows,cols] = size(r_chan);
% for i=1:numel(dist)
%     c_center = cell_info.cell_centers{i};
%     k_center = cell_info.kernel_centers{i};
%     x = [c_center(1),k_center(1)]/cols;
%     y = [rows-c_center(2),rows-k_center(2)]/rows;
%     annotation('arrow',x,y,'Color',[1,0,0]);
% end

