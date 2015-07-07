clear all;
close all;

%% Image path
im_noisy = 'noise-sc.tif';
im_denoised = 'denoised-sc.tif';
im_labels = 'labels-sc.tif';
% S = 150;

%% Read image data
% disp('Reading image ...');
I = double(imread(im_noisy));
% I = I(1:S,1:S);
J = zeros(size(I,1),size(I,2),3);
J(:,:,1) = I;
J(:,:,2) = I;
J(:,:,3) = I;
I = double(imread(im_denoised));
% I = I(1:S,1:S);
K = zeros(size(I,1),size(I,2),3);
K(:,:,1) = I;
K(:,:,2) = I;
K(:,:,3) = I;

%% Read groundtruth image data
L = double(imread(im_labels));
% L = L(1:S,1:S);
figure; imagesc(L);

%% Script parameters
segmentation_method = 'slic'; % 'slic', 'tp', 'nc' or 'gb'

index = 0;
iter = 10:5:500; 
for k=iter
    index = index+1;
    disp(num2str(index/numel(iter)));
    
    %% Segmentation parameters
    % nbSegments = 100;
    m = 10;
    colopt = 'median';
    sigma = 1.5;
    % k = 200;
    mi = 20;

    %% Construct superpixels on noisy image
    % disp('Computing superpixels on noisy image ...');
    if strcmp(segmentation_method,'slic')
        tic;
        [noise_labels, ~, ~] = slic(J, k, m);
        noise_label_edges = edge(noise_labels,0.01);
        t = toc;
    end
    if strcmp(segmentation_method,'tp')
        tic;
        [~,noise_label_edges,~] = turbopixels(J, k);
        noise_label_edges = double(noise_label_edges);
        noise_label_edges_inv_logical = logical(1-noise_label_edges);
        noise_label_edges_labeled = bwlabel(noise_label_edges_inv_logical,4);
        se = strel('disk',2);
        noise_labels = imdilate(noise_label_edges_labeled,se);
        t = toc;
    end
    if strcmp(segmentation_method,'gb')
        tic;
        noise_labels = double(graph_based(J, sigma, k, mi));
        noise_label_edges = double(edge(noise_labels));
        t = toc;
    end
    
% labeled_noise = zeros(size(noise_labels));
% for j=min(noise_labels(:)):max(noise_labels(:))
%     avg_pixels = mean2(I(noise_labels==j));
%     labeled_noise(noise_labels==j) = avg_pixels;
% end
% figure;
% imagesc(labeled_noise);colormap gray;

    % disp(['Superpixels computed on noisy image. This took ' num2str(t) ' seconds.']);

    %% Construct superpixels on denoised image
    % disp('Computing superpixels on denoised image ...');
    if strcmp(segmentation_method,'slic')
        tic;
        [denoised_labels, ~, ~] = slic(K, k, m);
        denoised_label_edges = edge(denoised_labels,0.01);
        t = toc;
    end
    if strcmp(segmentation_method,'tp')
        tic;
        [~,denoised_label_edges,~] = turbopixels(K, k);
        denoised_label_edges = double(denoised_label_edges);
        denoised_label_edges_inv_logical = logical(1-denoised_label_edges);
        denoised_label_edges_labeled = bwlabel(denoised_label_edges_inv_logical,4);
        se = strel('disk',2);
        denoised_labels = imdilate(denoised_label_edges_labeled,se);
        t = toc;
    end
    if strcmp(segmentation_method,'gb')
        tic;
        denoised_labels = double(graph_based(K, sigma, k, mi));
        denoised_label_edges = double(edge(denoised_labels));
        t = toc;
    end
    
% labeled_denoised = zeros(size(denoised_labels));
% for j=min(denoised_labels(:)):max(denoised_labels(:))
%     avg_pixels = mean2(I(denoised_labels==j));
%     labeled_denoised(denoised_labels==j) = avg_pixels;
% end
% figure;
% imagesc(labeled_denoised);colormap gray;

    % disp(['Superpixels computed on denoised image. This took ' num2str(t) ' seconds.']);

    %% Compute quality measures
    % disp('Computing quality measures ...');
    L_labels = imfill(L)+1;
    u_e_noise(index) = under_segmentation_error(L_labels, max(L_labels(:)), noise_labels, max(noise_labels(:)));
    u_e_denoised(index) = under_segmentation_error(L_labels, max(L_labels(:)), denoised_labels, max(denoised_labels(:)));
    % disp(['Under-segmentation error on noisy image: ' num2str(u_e_noise)]);
    % disp(['Under-segmentation error on denoised image: ' num2str(u_e_denoised)]);
    % [rowsL, colsL] = find(L);
    % [rowsN, colsN] = find(noise_label_edges);
    % [rowsD, colsD] = find(denoised_label_edges);
    % d_max_noise = hausdorffSuperPixel([rowsL, colsL], [rowsN, colsN], 0);
    % d_mean_noise = hausdorffSuperPixel([rowsL, colsL], [rowsN, colsN], 1);
    % d_max_denoised = hausdorffSuperPixel([rowsL, colsL], [rowsD, colsD], 0);
    % d_mean_denoised = hausdorffSuperPixel([rowsL, colsL], [rowsD, colsD], 1);
    [d_max_noise, d_mean_noise] = housedorf_superpixel(double(L), numel(unique(L))-1, double(noise_label_edges));
    [d_max_denoised, d_mean_denoised] = housedorf_superpixel(double(L), numel(unique(L))-1, double(denoised_label_edges));
    d_max_noises(index) = d_max_noise;
    d_mean_noises(index) = d_mean_noise;
    d_max_denoiseds(index) = d_max_denoised;
    d_mean_denoiseds(index) = d_mean_denoised;
    % disp(['Haussdorf distances on noisy image: ' num2str(d_max_noise) ' (max) - ' num2str(d_mean_noise) ' (mean)']);
    % disp(['Haussdorf distances on denoised image: ' num2str(d_max_denoised) ' (max) - ' num2str(d_mean_denoised) ' (mean)']);

    %% Plot results
    C = J;
    C(:,:,1) = C(:,:,1)-255*noise_label_edges;
    C(:,:,2) = C(:,:,2)-255*noise_label_edges;
    C(:,:,3) = C(:,:,3)-255*noise_label_edges;
    C = max(C, 0);
    D = K;
    D(:,:,1) = D(:,:,1)-255*denoised_label_edges;
    D(:,:,2) = D(:,:,2)-255*denoised_label_edges;
    D(:,:,3) = D(:,:,3)-255*denoised_label_edges;
    D = max(D, 0);
%     figure;
%     imshow(uint8(J));
%     figure;
%     imshow(uint8(K));
%     figure;
%     imshow(uint8(noise_labels)); colormap jet;
%     figure;
%     imshow(uint8(denoised_labels)); colormap jet;
%     figure;
%     imshow(uint8(C));
%     figure;
%     imshow(uint8(D));
%     figure;
%     imagesc(L);
end

figure; plot(iter,u_e_noise,iter,u_e_denoised); title('Under-segmentation error');legend('Noise','Denoised');
figure; plot(iter,d_max_noises,iter,d_max_denoiseds,iter,d_mean_noises,iter,d_mean_denoiseds); title('Hausdorf distances');legend('MAX-noise','MAX-denoised','MEAN-noise','MEAN-denoised');