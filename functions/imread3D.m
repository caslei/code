function img = imread3D(path)

info = imfinfo(path);
width = info(1).Width;
height = info(1).Height;
num_images = numel(info);
% img = zeros(height,width,num_images);
img = zeros(width,num_images);
for K=1:num_images
    disp(num2str(K/num_images));
    % img(:,:,K) = imread(path,'Index',K);
    im = imread(path,'Index',K);
    img(:,K) = im(200,:);
end

end

