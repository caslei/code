function nim=drawmask(im,mask)
im=double(im);
nim=zeros(size(im,1),size(im,2),3);
nbits = 16;
if (size(im,3)==1)    
    nim(:,:,1)=im.*double(~mask)+0.*(mask);
    nim(:,:,2)=im.*double(~mask)+0.*(mask);
    nim(:,:,3)=im.*double(~mask)+(2^nbits-1).*(mask);
else
    nim(:,:,1)=im(:,:,1).*double(~mask)+0.*(mask);
    nim(:,:,2)=im(:,:,2).*double(~mask)+0.*(mask);
    nim(:,:,3)=im(:,:,3).*double(~mask)+(2^nbits-1).*(mask);  
end

end