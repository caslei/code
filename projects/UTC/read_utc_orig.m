% Read UTC file
% version 0.1
% author: hiep.luong@telin.ugent.be
clear all
close all

filename = 'pre li 148 nr2';
filename_utc = strcat(filename,'.utc');
gunzip(filename_utc);

fid = fopen(filename);

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
delete(filename);

image = zeros(r,c,nr,'uint8');

for i = 1:600
    image(:,:,i) = flipud(rot90(image_temp(:,:,i)));
end
figure;imshow(image(:,:,200));
clear image_temp;

% crop image data
image = image(61:376,29:431,2:600); % this is the final image volume (!)

%for i = 1:599;figure(1);imshow(image(:,:,i));pause(0.1);end;
%for i = 1:316;figure(1);imshow(squeeze(image(i,:,:)));pause(0.1);end;
%for i = 1:403;figure(1);imshow(squeeze(image(:,i,:)));pause(0.1);end;

%for i = 1:403;figure(1);imshow(128+(squeeze(image(:,i,:)) - circshift(squeeze(image(:,i,:)),[1 0])));pause(0.1);end;

im = squeeze(image(:,200,:));
figure, imshow(im);
h = impoly(gca, [1,150;100,150;200,150;300,150;400,150;500,150;599,150;599,200;500,200;400,200;300,200;200,200;100,200;1,200]);
position = wait(h);