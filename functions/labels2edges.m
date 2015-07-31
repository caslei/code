
% Converts a labeled segmentation to segmentation boundaries
function edges = labels2edges(labels)

grad = imfilter(labels,[-1 3; -1 -1]);
edges = abs(grad)>0;

% edges = edge(labels,0);

end

