function F = ufft2(f)
% Apply a unitary Fast Fourier Transform

F = sqrt(numel(f)) ./ fft2(f);

end

