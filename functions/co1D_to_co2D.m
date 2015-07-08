function [i,j] = co1D_to_co2D(n,mat_size)

j = mod(n-1,mat_size(2))+1;
i = floor((n-1)/mat_size(2))+1;

end

