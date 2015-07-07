function image = read_utc(dir,filename)

filename_utc = strcat(dir,filename,'.utc');
gunzip(filename_utc);

fid = fopen(strcat(dir,filename));

nr = 600;
r = 576;
c = 768;

flag = 0;

while (~feof(fid) && flag == 0)
    % look for "</utc-session>"
    data = fread(fid, 1);
    if (data == '<')
        data = fread(fid, 1);
        if (data == '/')
            data = fread(fid, 1);
            if (data == 'u')
                data = fread(fid, 1);
                if (data == 't')
                    data = fread(fid, 1);
                    if (data == 'c')
                        data = fread(fid, 1);
                        if (data == '-')
                            data = fread(fid, 1);
                            if (data == 's')
                                data = fread(fid, 1);
                                if (data == 'e')
                                    data = fread(fid, 1);
                                    if (data == 's')
                                        data = fread(fid, 1);
                                        if (data == 's')
                                            data = fread(fid, 1);
                                            if (data == 'i')
                                                data = fread(fid, 1);
                                                if (data == 'o')
                                                    data = fread(fid, 1);
                                                    if (data == 'n')
                                                        data = fread(fid, 1);
                                                        if (data == '>')
                                                            % start reading image data
                                                            imdata = fread(fid, nr*r*c);
                                                            image_temp = uint8(reshape(imdata,c,r,nr));
                                                            clear imdata;
                                                            flag = 1;
                                                        end
                                                    end
                                                end
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end
end

fclose(fid);
delete(strcat(dir,filename));

image = zeros(r,c,nr,'uint8');

for i = 1:600
    image(:,:,i) = flipud(rot90(image_temp(:,:,i)));
end
clear image_temp;

% crop image data
image = image(61:376,29:431,2:600); % this is the final image volume (!)

end