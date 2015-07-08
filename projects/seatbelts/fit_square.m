function [h, w] = fit_square(glcm)

i = size(glcm, 1);
while sum(glcm(i,:) ~= 0) == 0 && i>1
    i = i-1;
end
h = i;
i = size(glcm, 2);
while sum(glcm(:,i) ~= 0) == 0 && i>1
    i = i-1;
end
w = i;

end

