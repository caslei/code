% Checks the signal dependency of the noise in 3D EM images by comparing
% the standard deviation of the noise for various intensities. 
% In order to obtain a noise signal, the mean intensity is subtracted from
% the image. Therefore, it is assumed the images correspond to 'constant'
% intensity areas. 

num_images = 11; 
num_patches = 10; 

% for i=1:num_images
%     im_path = strcat(num2str(400+100*i),'ns.dm3');
%     I = imreadDM3(im_path);
%     
%     imagesc(I);
%     
%     for j=1:num_patches
%         [x0, y0] = getpts();
%         [x1, y1] = getpts();
%         
%         J = I(x0:x1,y0:y1);
%         
%         patch_path = strcat(num2str(400+100*i), 'ns_patch', num2str(j), '.tif');
%         imwrite(J, patch_path);
%     end
% end

rel_noise_amounts = zeros(num_images*num_patches,1);
dwell_times = zeros(num_images*num_patches,1);

h = waitbar(0, 'Busy ...');
i0 = 5;
j0 = 1;
for i=i0:num_images
    for j=j0:num_patches
        patch_path = strcat(num2str(400+100*i), 'ns_patch', num2str(j), '.tif');
        I = double(imread(patch_path));
        % invert
        I = 2^16 - I;
        intensity = mean2(I);
        I = I - mean2(I);
        
        dwell_time = 400+100*i;
        std_noise = std2(I);
        rel_noise_amount = std_noise/dwell_time;
        
        dwell_times((i-1)*num_patches+j, 1) = dwell_time;
        rel_noise_amounts((i-1)*num_patches+j, 1) = rel_noise_amount;
        
        waitbar(((i-1)*num_patches+j)/(num_images*num_patches));
    end
end
close(h);

figure('Name','\sigma / dwell time','NumberTitle','off');
f = fit(dwell_times(41:end,1), rel_noise_amounts(41:end,1), 'poly2');
plot(f, dwell_times(41:end,1), rel_noise_amounts(41:end,1));
% f = fit(dwell_times, stds, 'poly1');
% plot(dwell_times, stds, '*');
legend('Data','Fitted curve');
title('\sigma / dwell time');
% title(strcat('Equation fitted curve: y = ',num2str(f.p1),'*x+',num2str(f.p2)));
xlabel('Dwell time (ns)');
ylabel('Signal to noise ratio');