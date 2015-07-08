

I = imread('data_grayvalue/patch_gray_4.tif');
K = 30; 
gray_levels = 50;

[GLCMs_V, GLCMs_H] = extract_GLCMs(I, K, gray_levels);

h_thresh = 17;
w_thresh = 17;
a_thresh = 9;
b_thresh = 3;

opacity = 0.2;
N_R = floor(size(I,1)/K);
N_C = floor(size(I,2)/K);
overlay = ones(size(I,1), size(I,2));
for m=0:N_R-1
    for n=0:N_C-1
        % Compute GLCM parameters
        [h, w] = fit_square(GLCMs_V(:,:,m+1,n+1));
        ellipse = fit_ellips(GLCMs_H(:,:,m+1,n+1));
        a = ellipse.a;
        b = ellipse.b;
        if (size(a) == 0)
            a = a_thresh;
        end
        if (size(b) == 0)
            b = b_thresh;
        end
        
        if ~(h < h_thresh && w < w_thresh && a < a_thresh && b < b_thresh)
            overlay(m*K+1:(m+1)*K,n*K+1:(n+1)*K) = 1-opacity;
        end
    end
end

rgb = zeros(size(I,1), size(I,2),3);
rgb(:,:,1) = 255;
imshow(rgb);
hold on;
h = imshow(I);
hold off;
set(h, 'AlphaData', overlay);
