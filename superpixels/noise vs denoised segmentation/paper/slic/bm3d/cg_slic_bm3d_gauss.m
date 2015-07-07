
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
sigma_min = 5;          sigma_inc = 5;          sigma_max = 10;
nbSegments_min = 5;     nbSegments_inc = 5;     nbSegments_max = 10;
m_min = 5;              m_inc = 5;              m_max = 10;
Q_noise = zeros((sigma_max-sigma_min)/sigma_inc+1, (nbSegments_max-nbSegments_min)/nbSegments_inc+1, (m_max-m_min)/m_inc+1);
Q_denoised = Q_noise;
for sigma=sigma_min:sigma_inc:sigma_max
    
    for nbSegments=nbSegments_min:nbSegments_inc:nbSegments_max
        
        for m=m_min:m_inc:m_max

            sigma_i = sigma/sigma_inc;
            nbSegments_i = nbSegments/nbSegments_inc;
            m_i = m/m_inc;

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
            [noise_labels, ~, ~] = slic(J, nbSegments, m);
            noise_label_edges = edge(noise_labels,0.01);

            % Construct superpixels on denoised image
            [denoised_labels, ~, ~] = slic(K, nbSegments, m);
            denoised_label_edges = edge(denoised_labels,0.01);

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
            
            Q_noise(sigma_i,nbSegments_i,m_i) = u_e_noise;
            Q_denoised(sigma_i,nbSegments_i,m_i) = u_e_denoised;
            
        end
        
    end
    
end

%% Save results
str_noise_output = strcat('Q_noise_',num2str(sigma_min),'_',num2str(sigma_inc),'_',num2str(sigma_max),'_',num2str(nbSegments_min),'_',num2str(nbSegments_inc),'_',num2str(nbSegments_max),'_',num2str(m_min),'_',num2str(m_inc),'_',num2str(m_max));
save(strcat(str_noise_output,'.mat'),'Q_noise');
str_denoised_output = strcat('Q_denoised_',num2str(sigma_min),'_',num2str(sigma_inc),'_',num2str(sigma_max),'_',num2str(nbSegments_min),'_',num2str(nbSegments_inc),'_',num2str(nbSegments_max),'_',num2str(m_min),'_',num2str(m_inc),'_',num2str(m_max));
save(strcat(str_denoised_output,'.mat'),'Q_denoised');

%% Save to video
% The time dimension depicts the noise standard deviation sigma
Q_noise = (Q_noise-min(Q_noise(:)))/(max(Q_noise(:))-min(Q_noise(:)));
Q_denoised = (Q_denoised-min(Q_denoised(:)))/(max(Q_denoised(:))-min(Q_denoised(:)));
writerObj = VideoWriter(strcat(str_noise_output,'.avi'), 'Grayscale AVI');
writerObj.FrameRate = 1;
open(writerObj);
for k = 1:size(Q_noise,1)
   writeVideo(writerObj,squeeze(Q_noise(k,:,:)));
end
close(writerObj);
writerObj = VideoWriter(strcat(str_denoised_output,'.avi'), 'Grayscale AVI');
writerObj.FrameRate = 1;
open(writerObj);
for k = 1:size(Q_denoised,1)
   writeVideo(writerObj,squeeze(Q_denoised(k,:,:)));
end
close(writerObj);