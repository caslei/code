
clear all;
close all;

% load image
img_orig = imread('Cardiac Muscle 3 rotated.tif');
[M,N,C] = size(img_orig);
lower_part = round(2*M/3):M;
middle_part = round(M/3)+1:round(2*M/3);
upper_part = 1:round(M/3);
img = double(img_orig(:,:,2));
img_lower = img(lower_part,:);
img_middle = img(middle_part,:);
img_upper = img(upper_part,:);
[Ml,Nl] = size(img_lower);
[Mm,Nm] = size(img_middle);
[Mu,Nu] = size(img_upper);

% construct noisy image
noise_lower = randn([Ml,Nl]);
noise_middle = randn([Mm,Nm]);

std = 60;
noise_lower = std*noise_lower;
noise_middle = std*noise_middle;

img_noisy_lower = img_lower + noise_lower;
img_noisy_middle = img_middle + noise_middle;

% lowpass filter
lowpass_filter_size = 50;
img_filtered = img_noisy_lower;

Q = 50;
for i=1:Q
    lowpass_filter_sigma = i/10;
    g_filter = fspecial('gaussian',lowpass_filter_size,lowpass_filter_sigma);
    img_filtered_temp = imfilter(img_noisy_lower,g_filter,'replicate');
    img_filtered(:,round((i-1)*Nl/Q)+1:round(i*Nl/Q)) = img_filtered_temp(:,round((i-1)*Nl/Q)+1:round(i*Nl/Q));
    
%     if i==1 || i==10 || i==20 || i==30 || i==40 || i==50
%         lp = (g_filter-min(g_filter(:)))./(max(g_filter(:))-min(g_filter(:)))*255;
%         figure;
%         imshow(uint8(lp));
%         imwrite(uint8(lp),['lowpass_sigma_' num2str(i) '.png']);
%     end
end

% show filtered image
% figure; 
% imshow(uint8(img_filtered));
img_final = img_orig;
img_final(lower_part,:,2) = uint8(img_filtered);
img_final(middle_part,:,2) = uint8(img_noisy_middle);
figure;
imshow(img_final);
imwrite(uint8(img_final),'lowpassFiltered.png');
