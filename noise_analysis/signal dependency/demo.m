% Checks the signal dependency of the noise in 3D EM images by comparing
% the standard deviation of the noise for various intensities. 
% In order to obtain a noise signal, the mean intensity is subtracted from
% the image. Therefore, it is assumed the images correspond to 'constant'
% intensity areas. 
clear all;
close all;

num_patches = 64;

vars = zeros(num_patches,1);
intensities = zeros(num_patches,1);

h = waitbar(0, 'Busy ...');
for i = 1:num_patches
    I = imread(strcat('001-',num2str(i),'.tif'));
    J = double(I);
    % invert
    J = 2^16 - J;
    
    intensity = mean2(J);
    J = J - intensity;
    [mu, sigma] = normfit(reshape(J, numel(J), 1));
    
    intensities(i, 1) = intensity;
    vars(i, 1) = sigma^2;
    
    waitbar(i/num_patches);
end
close(h);

figure('Name','Signal Dependency','NumberTitle','off');
f = fit(intensities, vars, 'poly1');
plot(f, intensities, vars);
legend('Data','Fitted curve');
title('Signal dependency');
title(strcat('Equation fitted curve: y = ',num2str(f.p1),'*x+',num2str(f.p2)));
xlabel('Signal intensity');
ylabel('Noise variance');