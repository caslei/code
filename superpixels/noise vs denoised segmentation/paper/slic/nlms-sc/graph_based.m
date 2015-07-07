% SLIC Simple Linear Iterative Clustering SuperPixels

function labels = graph_based(im, sigma, k, min)

    if (nargin < 2)
        sigma = 0.5;
        k = 500;
        min = 20;
    end
    
    imwrite(uint8(im), 'temp_in.ppm');
    system(['segment ' num2str(sigma) ' ' num2str(k) ' ' num2str(min) ' temp_in.ppm temp_out.ppm' ]);
    out = imread('temp_out.ppm');
    
    system('rm temp_in.ppm');
    system('rm temp_out.ppm');
    
    out2 = reshape(out, size(out,1)*size(out,2), size(out,3));
    out3 = unique(out2, 'rows');
    
    [labels,~] = rgb2ind(out,size(out3,1));
    
end