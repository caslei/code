
im_dir = '/ipi/shared/biology/dmbr/wallpapers/charging/';
im_basename = 'heart_dwell_';
im_ext = '.dm3';
im_ext_new = '.png';

N = 16;
for i=1:N
    img = double(dmread([im_dir im_basename num2str(i*0.5) im_ext]));
    img_patch = img(100:100+1999,3000:3000+1999);
    M = 23000;
    m = 17000;
    imwrite(uint8((img_patch-m)/(M-m)*255),[im_dir im_basename num2str(i*0.5) '_small' im_ext_new]);
end