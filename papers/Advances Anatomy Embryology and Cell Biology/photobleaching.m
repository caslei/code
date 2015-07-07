
im_dir = '/ipi/shared/biology/dmbr/wallpapers/bleaching/';
im_basename = 'bleaching lyso_t';
im_ext = '.png';

N0 = 7;
N = 33;

intensities = zeros(1,N-N0);
for i=N0:N-1
    img = imread([im_dir im_basename num2str(i) im_ext]);
    imwrite(img(340:340+255,20:20+255),[im_dir im_basename num2str(i) '_smaller' im_ext]);
    intensities(i-N0+1) = mean2(double(img));
end

figure;
plot(intensities);