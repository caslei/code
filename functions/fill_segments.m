
% Fills the different segments with the internal mean intensity
function filled_img = fill_segments(img,labels)

filled_img = zeros(size(img));
for j=min(labels(:)):max(labels(:))
    avg_pixels = mean2(img(labels==j));
    filled_img(labels==j) = avg_pixels;
end

end

