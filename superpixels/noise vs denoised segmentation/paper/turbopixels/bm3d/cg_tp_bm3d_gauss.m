
%% Image path
bsd_num = '118035';
im = strcat(bsd_num,'.jpg');

%% Read image data
I = double(imread(im));

%% Read groundtruth image data
load(strcat(bsd_num,'.mat'));
num_groundtruth = numel(groundTruth);
[L,M,N] = size(I);
b_im_gt = zeros(L,M,num_groundtruth);
for i=1:num_groundtruth
    b_im_gt(:,:,i) = groundTruth{i}.Boundaries;
end

%% Segmentation parameters
colopt = 'median';

%% Computation loop
% quality measure
sigma_min = 5;         sigma_inc = 5;          sigma_max = 75;
nbSegments_min = 5;    nbSegments_inc = 5;    nbSegments_max = 105;
Q_noise = zeros((sigma_max-sigma_min)/sigma_inc+1, (nbSegments_max-nbSegments_min)/nbSegments_inc+1);
Q_denoised = Q_noise;
for sigma=sigma_min:sigma_inc:sigma_max
    
    for nbSegments=nbSegments_min:nbSegments_inc:nbSegments_max

        sigma_i = sigma/sigma_inc;
        nbSegments_i = nbSegments/nbSegments_inc;

        % Noise/denoising parameters

        % Construct noisy image
        noise_3d = zeros(size(I));
        J = I;
        for i=1:3
            noise = sigma*randn(size(I,1),size(I,2));
            J(:,:,i) = J(:,:,i) + noise;
            noise_3d(:,:,i) = noise;
        end

        % Denoise noisy image
        K = I;
        for i=1:3
            D = fBM3D(J(:,:,i), 2*sigma);
            K(:,:,i) = double(abs(D));
        end

        % Construct superpixels on noisy image
        [~,noise_label_edges,~] = turbopixels(J, nbSegments);
        noise_label_edges = double(noise_label_edges);
        noise_label_edges_inv_logical = logical(1-noise_label_edges);
        noise_label_edges_labeled = bwlabel(noise_label_edges_inv_logical,4);
        se = strel('disk',2);
        noise_labels = imdilate(noise_label_edges_labeled,se);

        % Construct superpixels on denoised image
        [~,denoised_label_edges,~] = turbopixels(K, nbSegments);
        denoised_label_edges = double(denoised_label_edges);
        denoised_label_edges_inv_logical = logical(1-denoised_label_edges);
        denoised_label_edges_labeled = bwlabel(denoised_label_edges_inv_logical,4);
        se = strel('disk',2);
        denoised_labels = imdilate(denoised_label_edges_labeled,se);

        % Compute quality measures
        u_e_noise = zeros(1,num_groundtruth);
        u_e_denoised = zeros(1,num_groundtruth);
        for i=1:num_groundtruth
            BW = logical(1-b_im_gt(:,:,i));
            L = bwlabel(BW,4);
            se = strel('disk',1);
            label_gt = imdilate(L,se);

            u_e_noise(i) = under_segmentation_error(label_gt, max(label_gt(:)), noise_labels, max(noise_labels(:)));
            u_e_denoised(i) = under_segmentation_error(label_gt, max(label_gt(:)), denoised_labels, max(denoised_labels(:)));
        end
        u_e_noise = mean(u_e_noise);
        u_e_denoised = mean(u_e_denoised);

        Q_noise(sigma_i,nbSegments_i) = u_e_noise;
        Q_denoised(sigma_i,nbSegments_i) = u_e_denoised;
        
    end
    
end

%% Save results
str_noise_output = strcat('Q_noise_',num2str(sigma_min),'_',num2str(sigma_inc),'_',num2str(sigma_max),'_',num2str(nbSegments_min),'_',num2str(nbSegments_inc),'_',num2str(nbSegments_max));
save(strcat(str_noise_output,'.mat'),'Q_noise');
str_denoised_output = strcat('Q_denoised_',num2str(sigma_min),'_',num2str(sigma_inc),'_',num2str(sigma_max),'_',num2str(nbSegments_min),'_',num2str(nbSegments_inc),'_',num2str(nbSegments_max));
save(strcat(str_denoised_output,'.mat'),'Q_denoised');