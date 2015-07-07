% Estimate noise signal dependency in EM.
function f = estimate_sigdep(im_training_path, ...
                             im_sigdep_path, ...
                             n_flat, ...
                             n_texture, ...
                             wnd_size, ...
                             step)
% Given an EM image (im_training_path), the user selects n_flat and 
% n_texture (2*wnd_size+1)x(2*wnd_size+1) regions corresponding to expected 
% flat and textured regions, respectively. 
% Next, based on this training data, an SVM classifier is trained. 
% When the SVM classifier is trained, another EM image (im_sigdep_path) is
% scanned and expected flat areas are detected using SVM classification. 
% Lastly, the expected flat areas are used in order to estimate signal
% dependency in the noise. 

disp('Selecting expected flat patches ...');
flat_training_features = select_patches(im_training_path, ...
                                        n_flat, ...
                                        wnd_size, ...
                                        '    Please select an expected flat location. ', ...
                                        'flat_training_patches.mat', ...
                                        'flat_training_features.mat'); 
disp('Selecting expected textured patches ...');
textured_training_features = select_patches(im_training_path, ...
                                            n_texture, ...
                                            wnd_size, ...
                                            '    Please select an expected textured location. ', ...
                                            'textured_training_patches.mat', ...
                                            'textured_training_features.mat'); 
features = [flat_training_features; ...
            textured_training_features];
labels = cell(n_flat+n_texture,1);
for i=1:n_flat
    labels{i} = 'flat';
end
for i=n_flat+1:n_flat+n_texture
    labels{i} = 'textured';
end

disp('Training SVM classifier ...');
svm_struct = svmtrain(features, ...
                      labels);

disp('Detecting flat patches with SVM classifier ...');
flat_patch_coordinates = detect_flat_patches(svm_struct, ...
                                             im_sigdep_path, ...
                                             wnd_size, ...
                                             step, ...
                                             'detected_flat_patches.mat');

disp('Estimating signal dependency function ...');
f = est_sig_dep(flat_patch_coordinates, ...
                im_sigdep_path, ...
                wnd_size);
                                         
end

% Select n patches of size (2*wnd_size+1)x(2*wnd_size+1) from the image. 
function patch_features = select_patches(im_path, ...
                                         n, ...
                                         wnd_size, ...
                                         message, ...
                                         patches_filename, ...
                                         features_filename)
    
     num_levels = 32;
     if strcmp(im_path(end-3:end),'.dm3')
         [~,im] = dmread(im_path);
     else
         im = imread(im_path);
     end
     [M,N] = size(im);
     
     figure; imshow(im,[]);
     
     n_features = 22;
     patches = zeros(2*wnd_size+1,2*wnd_size+1,n);
     patch_features = zeros(n,n_features);
     for i=1:n
         disp(message);
         [col,row] = ginput(1);
         row = round(row); col = round(col);
         while row<=wnd_size || row>M-wnd_size || col<=wnd_size || col>N-wnd_size
             disp(['    Invalid point selected ... please make sure there is a margin of ' num2str(wnd_size) ' pixels around the selected point. ']);
             [col,row] = ginput(1);
             row = round(row); col = round(col);
         end
         disp(['    Valid point ! (' num2str(i) '/' num2str(n) ')']);
         disp('        Computing Haralick features ... ');
         patch = im(row-wnd_size:row+wnd_size,col-wnd_size:col+wnd_size);
         patches(:,:,i) = patch;
         patch_features(i,:) = haralick_features(patch,num_levels);
         disp('        Done');
     end
     
     save(patches_filename,'patches');
     save(features_filename,'patch_features');
     
     close all;
end

% Detect expected flat patches using a trained SVM classifier. 
function flat_patch_coordinates = detect_flat_patches(svm_struct, ...
                                                      im_path, ...
                                                      wnd_size, ...
                                                      step, ...
                                                      detected_flat_patches_filename)
    
    num_levels = 32;
    if strcmp(im_path(end-3:end),'.dm3')
         [~,im] = dmread(im_path);
    else
        im = imread(im_path);
    end
    [M,N] = size(im);
    
    i = 1;
    max_rel_r = floor((M-2*wnd_size)/step);
    max_rel_c = floor((N-2*wnd_size)/step);
    flat_patch_coordinates = zeros(max_rel_r*max_rel_c,2);
    patches = zeros(2*wnd_size+1,2*wnd_size+1,max_rel_r*max_rel_c);
    h = waitbar(0,'Scanning image for flat patches ...');
    for r=wnd_size+1:step:M-wnd_size
        rel_r = (r-(wnd_size+1))/step;
        for c=wnd_size+1:step:N-wnd_size
            rel_c = (c-(wnd_size+1))/step;
            patch = im(r-wnd_size:r+wnd_size,c-wnd_size:c+wnd_size);
            features = haralick_features(patch,num_levels);
            class = svmclassify(svm_struct, features');
            if strcmp(class,'flat')
                flat_patch_coordinates(i,1) = r;
                flat_patch_coordinates(i,2) = c;
                patches(:,:,i) = patch;
                i = i+1;
            end
            waitbar((rel_r*max_rel_c+rel_c)/(max_rel_r*max_rel_c));
        end
    end
    close(h);
    flat_patch_coordinates = flat_patch_coordinates(1:i-1,:);
    patches = patches(:,:,1:i-1);
    
    save(detected_flat_patches_filename,'patches');
    
end

% Estimate noise signal dependency using the expected flat patches. 
function f = est_sig_dep(flat_patch_coordinates, ... 
                         im_path, ...
                         wnd_size)
    
    if strcmp(im_path(end-3:end),'.dm3')
         [~,im] = dmread(im_path);
    else
        im = imread(im_path);
    end

    num_patches = size(flat_patch_coordinates,1);
    vars = zeros(num_patches,1);
    intensities = zeros(num_patches,1);
    
    for i=1:num_patches
        r = flat_patch_coordinates(i,1);
        c = flat_patch_coordinates(i,2);
        patch = im(r-wnd_size:r+wnd_size,c-wnd_size:c+wnd_size);
        intensity = mean2(patch);
        [~, sigma] = normfit(reshape(patch, numel(patch), 1));
        intensities(i,1) = intensity;
        vars(i,1) = sigma^2;
    end

    f = fit(intensities, vars, 'poly1');
    figure('Name','Signal Dependency','NumberTitle','off');
    plot(f, intensities, vars);
    legend('Data','Fitted curve');
    title('Signal dependency');
    title(strcat('Equation fitted curve: y = ',num2str(f.p1),'*x+',num2str(f.p2)));
    xlabel('Signal intensity');
    ylabel('Noise variance');
    
end