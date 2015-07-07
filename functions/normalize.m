function J = normalize(I, minimum, maximum)
% Rescales an image such that the minimum and maximum values are given by
% minimum and maximum, respectively. When no min or max are given, it is rescaled
% between 0 and 2^nbits-1.

nbits = 8;

m = double(min(I(:)));
M = double(max(I(:)));

if (nargin < 3)
    minimum = 0;
    maximum = 2^nbits-1;
end

J = (double(I)-m) ./ (M-m) .* (maximum-minimum) + minimum;

end

