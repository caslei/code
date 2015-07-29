
% Converts a labeled segmentation to segmentation boundaries
function edges = labels2edges(labels)

grad = imfilter(labels,[3 -1; -1 -1]);
edges = abs(grad)>0;

end

