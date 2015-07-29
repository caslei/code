function boundary = fTP(img,numSuperpixels,timeStep,maxIterations)

    if nargin < 3
        timeStep = 0.5;
    end
    if nargin < 4
        maxIterations = 500;
    end
    
    display_int = 0;
    
    phi = evolve_height_function_N(img, timeStep, maxIterations, 'superpixels', display_int, [], numSuperpixels);
    
    if (size(img,3) > 1)
        smooth_img = evolve_height_function_N(rgb2gray(img), 0.1, 10, 'curvature', 0, 0);
    else
        smooth_img = evolve_height_function_N(img, 0.1, 10, 'curvature', 0, 0);
    end

    [gx,gy] = height_function_der(255*smooth_img);
    mag = sqrt(gx.^2 + gy.^2);
    speed2 = exp(- mag/5);
    boundary = get_superpixel_boundaries(phi,speed2);
    
end

