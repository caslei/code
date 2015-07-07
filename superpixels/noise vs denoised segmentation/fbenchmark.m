function [hd_max_noise, hd_mean_noise, hd_max_denoised, hd_mean_denoised, C, D] = fbenchmark(sigma)

    %% Initial parameters
    bench = 1; % benchmark bsd image / otherwise em image
    sig_corr = 1; % signal-dependent, correlated noise / otherwise signal-dependent
    if bench
        bsd_num = '118035'; % image
        im = strcat(bsd_num,'.jpg');
    else
        im = 'noise-s.tif';
        im_labels = 'labels-s.tif';
    end
    disp_denoising_result = 0;
    compute_quality = 1;

    %% Load image
    if bench
        I = double(imread(im));
    else
        I = double(imread(im));
        J = zeros(size(I,1),size(I,2),3);
        J(:,:,1) = I;
        J(:,:,2) = I;
        J(:,:,3) = I;
        I = J;
    end

    %% Load groundtruth
    if bench
        load(strcat(bsd_num,'.mat'));
        num_groundtruth = numel(groundTruth);
        [L,M,N] = size(I);
        b_im_gt = zeros(L,M,num_groundtruth);
        for i=1:num_groundtruth
            b_im_gt(:,:,i) = groundTruth{i}.Boundaries;
        end
        L = double((sum(b_im_gt,3)/3)>0);
    else
        L = double(imread(im_labels));
    end

    %% Add noise
    % params
    % sigma = 20; 
    sigma_0 = sigma^2;
    alpha = 1; 
    W = 3;
    h = 2;
    T = 0.7;
    wnd_size = 5;
    weighting_function_name = 'MODIFIED_BISQUARE'; 
    V = 0;
    if bench  
        noise_3d = zeros(size(I));
        PS_3d = zeros(size(I));
        J = I;
        if sig_corr
            for i=1:3
                [noise, PS] = emnoise(I(:,:,i), alpha, sigma_0);
                J(:,:,i) = J(:,:,i) + noise;
                noise_3d(:,:,i) = noise;
                PS_3d(:,:,i) = PS;
            end
        else 
            for i=1:3
                noise = fmnoise(I(:,:,i), alpha, sigma_0);
                J(:,:,i) = J(:,:,i) + noise;
                noise_3d(:,:,i) = noise;
            end
        end
    else
        PS_3d = zeros(size(I));
        if sig_corr
            for i=1:3
                [~, PS] = emnoise(I(:,:,i), alpha, sigma_0);
                PS_3d(:,:,i) = PS;
            end
        end
    end

    %% Compute denoised image
    if sig_corr
        disp('Denoising noisy image ...');
        K = I;
        tic
        for i=1:3
            [D, ~, ~] = fNLMS_SC(J(:,:,i), J(:,:,i), h, T, PS_3d(:,:,i), alpha, sigma_0, W, wnd_size, weighting_function_name, V);
            K(:,:,i) = double(abs(D));
        end
        t = toc;
        disp(['Image denoised. This took ' num2str(t) ' seconds.']);
    else
        disp('Denoising noisy image ...');
        K = I;
        tic
        for i=1:3
            D = fNLMS_S(J(:,:,i), h, alpha, sigma_0, W, wnd_size, weighting_function_name, V);
            K(:,:,i) = double(abs(D));
        end
        t = toc;
        disp(['Image denoised. This took ' num2str(t) ' seconds.']);
    end

    if disp_denoising_result
        figure;
        subplot(1,2,1), subimage(uint8(J));
        subplot(1,2,2), subimage(uint8(K));
    end

    %% Compute superpixels on noisy image
    % noisy segmentation params
    nbSegments = 500;
    % nbSegments = 500;
    m = 1.5*sigma+35;
    colopt = 'median';

    disp('Computing superpixels on noisy image ...');
    tic;
    [noise_labels, ~, ~] = slic(J, nbSegments, m);
    % noise_label_edges = edge(noise_labels,0);
    noise_label_edges = edges(noise_labels);
    t = toc;
    disp(['Superpixels computed on noisy image. This took ' num2str(t) ' seconds.']);

    %% Compute superpixels on denoised image
    % denoised segmentation params
    nbSegments = 500;
    % nbSegments = 500;
    m = 0.5*sigma;
    colopt = 'median';

    disp('Computing superpixels on denoised image ...');
    tic;
    [denoised_labels, ~, ~] = slic(K, nbSegments, m);
    % denoised_label_edges = edge(denoised_labels,0);
    denoised_label_edges = edges(denoised_labels);
    t = toc;
    disp(['Superpixels computed on denoised image. This took ' num2str(t) ' seconds.']);

    %% Compute quality measures
    if compute_quality
        disp('Computing quality measures ...');
        % under-segmentation error
        if bench
            % u_e_noise = zeros(1,num_groundtruth);
            % u_e_denoised = zeros(1,num_groundtruth);
    %         hd_max_noise = zeros(1,num_groundtruth);
    %         hd_mean_noise = zeros(1,num_groundtruth);
    %         hd_max_denoised = zeros(1,num_groundtruth);
    %         hd_mean_denoised = zeros(1,num_groundtruth);
    %         for i=1:num_groundtruth
    %             BW = logical(1-b_im_gt(:,:,i));
    %             L = bwlabel(BW,4);
    %             se = strel('disk',1);
    %             label_gt = imdilate(L,se);
    % 
    %             u_e_noise(i) = under_segmentation_error(label_gt, max(label_gt(:)), noise_labels, max(noise_labels(:)));
    %             u_e_denoised(i) = under_segmentation_error(label_gt, max(label_gt(:)), denoised_labels, max(denoised_labels(:)));
    %         end
    %         u_e_noise = mean(u_e_noise);
    %         u_e_denoised = mean(u_e_denoised);

            % hausdorf distance
    %         for i=1:num_groundtruth
    %             BW = logical(1-b_im_gt(:,:,i));
    %             L = bwlabel(BW,4);
    %             se = strel('disk',1);
    %             label_gt = imdilate(L,se);
    % 
    %             [d_max_noise, d_mean_noise] = housedorf_superpixel(double(L), numel(unique(L))-1, double(noise_label_edges));
    %             [d_max_denoised, d_mean_denoised] = housedorf_superpixel(double(L), numel(unique(L))-1, double(denoised_label_edges));
    %             hd_max_noise(i) = d_max_noise;
    %             hd_mean_noise(i) = d_mean_noise;
    %             hd_max_denoised(i) = d_max_denoised;
    %             hd_mean_denoised(i) = d_mean_denoised;
    %         end
    %         hd_max_noise = mean(hd_max_noise);
    %         hd_mean_noise = mean(hd_mean_noise);
    %         hd_max_denoised = mean(hd_max_denoised);
    %         hd_mean_denoised = mean(hd_mean_denoised);
            [hd_max_noise, hd_mean_noise] = housedorf_superpixel(double(L), numel(unique(L))-1, double(noise_label_edges));
            [hd_max_denoised, hd_mean_denoised] = housedorf_superpixel(double(L), numel(unique(L))-1, double(denoised_label_edges));
        else
            % L_labels = imfill(L)+1;
            % u_e_noise = under_segmentation_error(L_labels, max(L_labels(:)), noise_labels, max(noise_labels(:)));
            % u_e_denoised = under_segmentation_error(L_labels, max(L_labels(:)), denoised_labels, max(denoised_labels(:)));
            [hd_max_noise, hd_mean_noise] = housedorf_superpixel(double(L), numel(unique(L))-1, double(noise_label_edges));
            [hd_max_denoised, hd_mean_denoised] = housedorf_superpixel(double(L), numel(unique(L))-1, double(denoised_label_edges));
        end

        disp('Evaluation metrics: ');
        % disp(['    Under-segmentation error: ' num2str(u_e_noise) ' (noise) <-> ' num2str(u_e_denoised) ' (denoised)']);
        disp(['    Max hausdorf distance: ' num2str(hd_max_noise) ' (noise) <-> ' num2str(hd_max_denoised) ' (denoised)']);
        disp(['    Mean hausdorf distance: ' num2str(hd_mean_noise) ' (noise) <-> ' num2str(hd_mean_denoised) ' (denoised)']);
    end

    %% Compare overlays
    % Overlay noisy image
    C = J;
    C(:,:,1) = C(:,:,1)-255*noise_label_edges;
    C(:,:,2) = C(:,:,2)-255*noise_label_edges;
    C(:,:,3) = C(:,:,3)-255*noise_label_edges;
    C = max(C, 0);

    % Overlay denoised image
    D = K;
    D(:,:,1) = D(:,:,1)-255*denoised_label_edges;
    D(:,:,2) = D(:,:,2)-255*denoised_label_edges;
    D(:,:,3) = D(:,:,3)-255*denoised_label_edges;
    D = max(D, 0);

    % Display results
    % figure;
    % subplot(1,2,1), subimage(uint8(C));
    % subplot(1,2,2), subimage(uint8(D));
    
    C = uint8(C);
    D = uint8(D);
    
    % figure;
    % subplot(1,2,1), subimage(uint8(noise_labels));
    % subplot(1,2,2), subimage(uint8(denoised_labels));
end

