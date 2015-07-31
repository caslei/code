function [L_S,H_S,V_S,F_S] = extract_segmentation(params,pms,bg)

n_features = size(pms,3);
n_classes = size(pms,4);

class_pms = zeros(size(pms,1),size(pms,2),n_classes);
for nc=1:n_classes
    for nf=1:n_features
        class_pms(:,:,nc) = class_pms(:,:,nc) + params(nf,nc).*pms(:,:,nf,nc);
    end
end

% figure, imshow(class_pms(:,:,1),[]);
% figure, imshow(class_pms(:,:,2),[]);
% figure, imshow(class_pms(:,:,3),[]);

% extract segmentation from class probability maps
% disp('extracting segmentation from class probability maps ...');
[~,I_S] = max(class_pms,[],3);
L = I_S==1;
H = I_S==2;
V = I_S==3;

% figure,imshow(L,[]);
% figure,imshow(H,[]);
% figure,imshow(V,[]);

% disp('cleaning segmentation ...');
LL = medfilt2(L,[11 11]);
LLL = imclose(LL,strel('disk',3));
LLLL = imopen(LLL,strel('disk',5));
LLLLL = imfill(LLLL,'holes');
LLLLLL = bwareaopen(LLLLL, 1000);
% figure,imshow(L,[]);
% figure,imshow(LL,[]);
% figure,imshow(LLL,[]);
% figure,imshow(LLLL,[]);
% figure,imshow(LLLLL,[]);
% figure,imshow(LLLLLL,[]);

HH = medfilt2(H,[11 11]);
HHH = imclose(HH,strel('disk',11));
HHHH = imopen(HHH,strel('disk',4));
HHHHH = imfill(HHHH,'holes');
HHHHHH = bwareaopen(HHHHH, 2500);
% figure,imshow(H,[]);
% figure,imshow(HH,[]);
% figure,imshow(HHH,[]);
% figure,imshow(HHHH,[]);
% figure,imshow(HHHHH,[]);
% figure,imshow(HHHHHH,[]);

VV = medfilt2(V,[11 11]);
VVV = imclose(VV,strel('disk',11));
VVVV = imopen(VVV,strel('disk',4));
VVVVV = imfill(VVVV,'holes');
VVVVVV = bwareaopen(VVVVV, 2500);
% figure,imshow(V,[]);
% figure,imshow(VV,[]);
% figure,imshow(VVV,[]);
% figure,imshow(VVVV,[]);
% figure,imshow(VVVVV,[]);
% figure,imshow(VVVVVV,[]);

% final segmentation
L_S = LLLLLL;
H_S = HHHHHH;
V_S = VVVVVV;

% figure, imshow(uint16(drawmask(im,H_S)));
% figure, imshow(uint16(im));
% figure, imshow(uint16(drawmask(im,V_S)));

F_S = max(min(H_S+V_S,1)-L_S-bg,0);
% clean fiber segments
F_S = imdilate(bwmorph(bwmorph(F_S,'thin',30),'erode'),strel('disk',20));

% figure, imshow(uint16(im));
% figure, imshow(uint16(drawmask(im,fibers)));

end

