function E = compare_GLCMs(GLCMs, GLCMs_correct)

if ((ndims(GLCMs) ~= 4) || (ndims(GLCMs_correct) ~= 4))
    error('Parameters GLCMs and GLCMs_correct should both be 4-dimensional!');
end

if (size(GLCMs) ~= size(GLCMs_correct))
    error('Parameters GLCMs and GLCMs_correct should be the same size!');
end

GLCMs_RES = abs(GLCMs - GLCMs_correct);
E = sum(sum(GLCMs_RES, 2), 1);
E = reshape(E, [size(E,3), size(E,4)]);

end

