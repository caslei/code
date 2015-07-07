function E = edges(L)

[GX,GY] = gradient(L);
E = logical(min((abs(GX)>0)+(abs(GY)>0),1));

end

