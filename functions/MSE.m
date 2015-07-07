function mse = MSE(A, B)
% Compute the Mean Squared Error between two images

C = (double(A)-double(B)).^2;
mse = mean(C(:));