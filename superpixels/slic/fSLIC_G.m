% SLIC algorithm for grayscale images
% The distance function uses a simple Euclidean distance between
% intensities instead of LAB values

function labels = fSLIC_G(img,k,m,nItr)

    [rows, cols, chan] = size(img);
    if chan ~= 1
        error(['Error: required [MxN] image, input was of size [' num2str(size(img)) ']']);
    end
    
    % Convert image to L*a*b* colourspace.  This gives us a colourspace that is
    % nominally perceptually uniform. This allows us to use the euclidean
    % distance between colour coordinates to measure differences between
    % colours.  Note the image becomes double after conversion.  We may want to
    % go to signed shorts to save memory.
    % img = rgb2lab(img/255); 
    
    % Nominal spacing between grid elements assuming hexagonal grid
    S = sqrt(rows*cols / (k * sqrt(3)/2));
    
    % Get nodes per row allowing a half column margin at one end that alternates
    % from row to row
    nodeCols = round(cols/S - 0.5);
    % Given an integer number of nodes per row recompute S
    S = cols/(nodeCols + 0.5); 

    % Get number of rows of nodes allowing 0.5 row margin top and bottom
    nodeRows = round(rows/(sqrt(3)/2*S));
    vSpacing = rows/nodeRows;

    % Recompute k
    k = nodeRows * nodeCols;
    
    % Allocate memory and initialise clusters, labels and distances.
    C = zeros(4,k);          % Cluster centre data  1 is mean intensity value,
                             % 2:3 is row, col of centre, 4 is No of pixels
    labels = -ones(rows, cols);   % Pixel labels.
    d = inf(rows, cols);     % Pixel distances from cluster centres.
    
    % Initialise clusters on a hexagonal grid
    kk = 1;
    r = vSpacing/2;
    
    for ri = 1:nodeRows
        % Following code alternates the starting column for each row of grid
        % points to obtain a hexagonal pattern. Note S and vSpacing are kept
        % as doubles to prevent errors accumulating across the grid.
        if mod(ri,2), c = S/2; else c = S;  end
        
        for ci = 1:nodeCols
            cc = round(c); rr = round(r);
            C(1:3, kk) = [squeeze(img(rr,cc)); cc; rr];
            c = c+S;
            kk = kk+1;
        end
        
        r = r+vSpacing;
    end
    
    % Now perform the clustering.  10 iterations is suggested but I suspect n
    % could be as small as 2 or even 1
    S = round(S);  % We need S to be an integer from now on
    
    for n = 1:nItr
       for kk = 1:k  % for each cluster

           % Get subimage around cluster
           rmin = max(C(3,kk)-S, 1);   rmax = min(C(3,kk)+S, rows); 
           cmin = max(C(2,kk)-S, 1);   cmax = min(C(2,kk)+S, cols); 
           subim = img(rmin:rmax, cmin:cmax, :);  
           assert(numel(subim) > 0)
           
           % Compute distances D between C(:,kk) and subimage
           D = dist(C(:, kk), subim, rmin, cmin, S, m);

           % If any pixel distance from the cluster centre is less than its
           % previous value update its distance and label
           subd =  d(rmin:rmax, cmin:cmax);
           subl =  labels(rmin:rmax, cmin:cmax);
           updateMask = D < subd;
           subd(updateMask) = D(updateMask);
           subl(updateMask) = kk;
           
           d(rmin:rmax, cmin:cmax) = subd;
           labels(rmin:rmax, cmin:cmax) = subl;           
       end
       
       % Update cluster centres with mean values
       C(:) = 0;
       for r = 1:rows
           for c = 1:cols
              tmp = [img(r,c); c; r; 1];
              C(:, labels(r,c)) = C(:, labels(r,c)) + tmp;
           end
       end
       
       % Divide by number of pixels in each superpixel to get mean values
       for kk = 1:k 
           C(1:3,kk) = round(C(1:3,kk)/C(4,kk)); 
       end
       
       % Note the residual error, E, is not calculated because we are using a
       % fixed number of iterations 
    end
    
end

function D = dist(C, im, r1, c1, S, m)

    % Squared spatial distance
    %    ds is a fixed 'image' we should be able to exploit this
    %    and use a fixed meshgrid for much of the time somehow...
    [rows, cols] = size(im);
    [x,y] = meshgrid(c1:(c1+cols-1), r1:(r1+rows-1));
    x = x-C(2);  % x and y dist from cluster centre
    y = y-C(3);
    ds2 = x.^2 + y.^2;
    
    % Squared intensity difference
    dc2 = (im-C(1)).^2;
    
    D = sqrt(dc2 + m^2*(ds2/S^2));
    
end