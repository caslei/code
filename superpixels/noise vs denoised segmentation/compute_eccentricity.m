function e = compute_eccentricity(L)

w = 0.2;

M = max(L(:));
e_cum = 0;
for i=1:M
    L_i = L==i;
    % s_ecc = regionprops(L_i, 'Eccentricity');
    s = regionprops(L_i, 'Area', 'BoundingBox', 'Perimeter');
    e_cum_part = 0;
    sum_part = 0;
    full_area = 0;
    full_perim = 0;
    for j=1:numel(s)
        % e_cum_part = e_cum_part + getfield(s_ecc(j),'Eccentricity');
        area = getfield(s(j),'Area');
        full_area = full_area + area;
        bbox = getfield(s(j),'BoundingBox');
        perim = max(getfield(s(j),'Perimeter'),1);
        full_perim = full_perim + perim;
        r = max(bbox(3),bbox(4));
        % e_cum_part = e_cum_part + (4*pi*area/(perim*perim));
        % sum_part = sum_part + 1;
        % e_cum_part = e_cum_part + exp(area)*((1-w)*(area / (pi*r*r))+w*((2*pi*r) / perim));
        % sum_part = sum_part+exp(area);
    end
    % stockiness = (4*pi*full_area/(full_perim*full_perim))
    e_cum = e_cum + (4*pi*full_area/(full_perim*full_perim));
    % e_cum = e_cum + e_cum_part/sum_part;
end
e = e_cum/M;

end

