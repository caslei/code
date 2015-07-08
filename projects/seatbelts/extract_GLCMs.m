function [GLCMs_V, GLCMs_H] = extract_GLCMs(I, K, gray_levels)

% I: grayscale image
% K: patch size

N_R = floor(size(I,1)/K);
N_C = floor(size(I,2)/K);

GLCMs_V = zeros(gray_levels, gray_levels, N_R, N_C);
GLCMs_H = zeros(gray_levels, gray_levels, N_R, N_C);

h = waitbar(0, 'Please wait ...');
for m=0:N_R-1
    for n=0:N_C-1
        waitbar((m*N_C+n)/(N_R*N_C));
        J = I(m*K+1:(m+1)*K, n*K+1:(n+1)*K);

        GLCMs_temp = zeros(gray_levels, gray_levels, 4);

        % GLCM_N
        GLCMs_temp(:,:,1) = graycomatrix(J, 'NumLevels', gray_levels, 'Offset', [-1 0]);
        % GLCM_S
        GLCMs_temp(:,:,2) = graycomatrix(J, 'NumLevels', gray_levels, 'Offset', [1 0]);
        % GLCM_E
        GLCMs_temp(:,:,3) = graycomatrix(J, 'NumLevels', gray_levels, 'Offset', [0 1]);
        % GLCM_W
        GLCMs_temp(:,:,4) = graycomatrix(J, 'NumLevels', gray_levels, 'Offset', [0 -1]);

        GLCMs_V(:,:,m+1,n+1) = (GLCMs_temp(:,:,1) + GLCMs_temp(:,:,2))/2;
        GLCMs_H(:,:,m+1,n+1) = (GLCMs_temp(:,:,3) + GLCMs_temp(:,:,4))/2;
    end
end
close(h);

end