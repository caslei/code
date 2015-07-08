

I = imread('patch_gray_0.tif');
J = I(351:478,601:728);

gray_lvls = 100;
offset = [0 1];

glcm = graycomatrix(J, 'NumLevels', gray_lvls, 'Offset', offset);

[non_zero_ys, non_zero_xs] = find(glcm);

g = figure;
unique_xs = unique(non_zero_xs);
new_xs = zeros(2*numel(unique_xs), 1);
new_ys = zeros(2*numel(unique_xs), 1);
for i=1:numel(unique_xs)
    coords = find(non_zero_xs == unique_xs(i));
    [min_value, ~] = min(non_zero_ys(coords));
    [max_value, ~] = max(non_zero_ys(coords));
    
    new_xs(2*(i-1)+1) = unique_xs(i);
    new_xs(2*(i-1)+2) = unique_xs(i);
    new_ys(2*(i-1)+1) = min_value;
    new_ys(2*(i-1)+2) = max_value;
end

ellipse = fit_ellipse(new_xs, new_ys);
hold on;
scatter(new_xs, new_ys);
