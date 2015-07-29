
% Converts a boundary image into a labeled image, the boundaries are
% assumed 1 pixel wide
function labels = edges2labels(edges)

labels = bwlabel(1-double(edges),4);
labels = replace_edges(labels,2);

end

% Replaces the boundaries by the most common label in its neighborhood
function new_labels = replace_edges(labels,n)
    
[N,M] = size(labels);
new_labels = labels;
for i=1:N
    for j=1:M
        if labels(i,j)==0
            window = labels(min(max(i-n,1),N):min(max(i+n,1),N),min(max(j-n,1),N):min(max(j+n,1),N));
            window = nonzeros(window(:));
            uv = unique(window);
            counts = histc(window,uv);
            [~,ind] = max(counts);
            new_labels(i,j) = uv(ind);
        end
    end
end

end