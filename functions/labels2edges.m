
% Converts a labeled segmentation to segmentation boundaries
function edges = labels2edges(labels)

grad = imfilter(double(labels),[-1 3; -1 -1]);
edges = abs(grad)>0;

% edges = edge(labels,0);

% [GX,GY] = gradient(double(labels));
% edges = logical(min((abs(GX)>0)+(abs(GY)>0),1));

end

