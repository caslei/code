
% Fills the different segments with the internal mean intensity
function filled_img = fill_segments(img,labels)

if (size(img,3)==3)
    img_r = img(:,:,1);
    img_g = img(:,:,2);
    img_b = img(:,:,3);
    filled_img = zeros(size(img));
    for j=min(labels(:)):max(labels(:))
        filled_img_r = filled_img(:,:,1);
        filled_img_g = filled_img(:,:,2);
        filled_img_b = filled_img(:,:,3);
        filled_img_r(labels==j) = mean2(img_r(labels==j));
        filled_img_g(labels==j) = mean2(img_g(labels==j));
        filled_img_b(labels==j) = mean2(img_b(labels==j));
        filled_img(:,:,1) = filled_img_r;
        filled_img(:,:,2) = filled_img_g;
        filled_img(:,:,3) = filled_img_b;
    end
else 
    filled_img = zeros(size(img));
    for j=min(labels(:)):max(labels(:))
        avg_pixels = mean2(img(labels==j));
        filled_img(labels==j) = avg_pixels;
    end
end

end

