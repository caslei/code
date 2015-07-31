%% Adds a red mask on top of the image
function masked_img = mask(img,mask)

if size(img,3)==3
    masked_img = img;
else
    masked_img = zeros(size(img,1),size(img,2),3);
    masked_img(:,:,1) = img;
    masked_img(:,:,2) = img;
    masked_img(:,:,3) = img;
end

mask = min(double(mask)*255,255);
masked_img(:,:,1) = min(masked_img(:,:,1)+mask,255);
masked_img(:,:,2) = max(masked_img(:,:,2)-mask,0);
masked_img(:,:,3) = max(masked_img(:,:,3)-mask,0);

end