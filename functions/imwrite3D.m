function [] = imwrite3D(img,path)

for K=1:length(img(1,1,:))
   imwrite(uint16(img(:,:,K)),path, 'WriteMode','append','Compression','none');
end

end

