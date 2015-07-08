function img = imread3D(path)

info = imfinfo(path);
width = info(1).Width;
height = info(1).Height;
num_images = numel(info);
img = zeros(height,width,num_images);
h = waitbar(0,'Reading image data ...');
for K=1:num_images
    img(:,:,K) = imread(path,'Index',K);
    waitbar(K/num_images);
end
close(h);

end

