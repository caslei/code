function bw = thresh_and_clean(img)
    img_filtered = imfilter(img,fspecial('gaussian',75,75),'symmetric');
    [counts,centers] = hist(img_filtered(:),200);
    [~,~,ymin,imin] = extrema(counts);
    [~,ind] = max(ymin);
    T = centers(imin(ind));
    img_threshed = img_filtered<T;
    filled = imfill(img_threshed, 'holes');
    holes = filled & ~img_threshed;
    bigholes = bwareaopen(holes, 5000);
    smallholes = holes & ~bigholes;
    img_temp = img_threshed | smallholes;
    bw = imerode(img_temp,strel('disk',75));
end