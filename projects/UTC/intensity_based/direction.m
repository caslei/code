function d = direction(b,wnd_size)

[M,N] = size(b);
d = zeros(M,N)-Inf;
for i=1:M
    for j=1:N
        if b(i,j)
            dir = -Inf;
            n = 0;
            for k=max(i-wnd_size,1):min(i+wnd_size,M)
                for l=max(j-wnd_size,1):min(j+wnd_size,N)
                    if b(k,l)
                        dir = max(dir,0) + atan((k-i)/(l-j))*180/pi;
                        n = n+1;
                    end
                end
            end
            d(i,j) = dir/max(n,1);
        end
    end
end

end

