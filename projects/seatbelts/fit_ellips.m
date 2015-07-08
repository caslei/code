function ellipse = fit_ellips(glcm)

[non_zero_ys, non_zero_xs] = find(glcm);
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

end

