function f = uifft2(F)
% Apply a unitary, Inverse Fast Fourier Transform.

f = sqrt(numel(F)) .* ifft2(F);

end

