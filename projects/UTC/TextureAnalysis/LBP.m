% /***********************************************************************
%  * AUTHOR: Benhur Ortiz Jaramillo
%  * DATE:  08/04/2011
%  * NAME: LBP
%  * X. INPUT: Gray Scale Image of size WxH
%  * h. OUPUT: Histogram of the LBP image
%  * DESCRIPTION: Performs the LBP proposed by
%    TOjala02 in Multiresolution Gray-Scale and Rotation Invariant Texture
%    Classification with Local Binary Patterns
%  ***********************************************************************

function Y = LBP(X)

if size(X,3) > 1
    X = rgb2gray(X);
end
X = mat2gray(X,[0,255]);
r = sqrt(2)/2;
a = (1-r)*(1-r);
b = r*(1-r);
c = r*(1-r);
d = r*r;
H = [a b 0; c d 0; 0 0 0]; Xf{1} = filter2(H,X,'valid');
H = [0 1 0; 0 0 0; 0 0 0]; Xf{2} = filter2(H,X,'valid');
H = [0 a b; 0 c d; 0 0 0]; Xf{3} = filter2(H,X,'valid');
H = [0 0 0; 0 0 1; 0 0 0]; Xf{4} = filter2(H,X,'valid');
H = [0 0 0; 0 a b; 0 c d]; Xf{5} = filter2(H,X,'valid');
H = [0 0 0; 0 0 0; 0 1 0]; Xf{6} = filter2(H,X,'valid');
H = [0 0 0; a b 0; c d 0]; Xf{7} = filter2(H,X,'valid');
H = [0 0 0; 1 0 0; 0 0 0]; Xf{8} = filter2(H,X,'valid');
H = [0 0 0; 0 1 0; 0 0 0]; X = filter2(H,X,'valid');
Xf{1} = Xf{1} > X; Xf{2} = Xf{2} > X; Xf{3} = Xf{3} > X; Xf{4} = Xf{4} > X;
Xf{5} = Xf{5} > X; Xf{6} = Xf{6} > X; Xf{7} = Xf{7} > X; Xf{8} = Xf{8} > X;
j = [0 1 2 3 4 5 6 7];
XLBP = zeros([size(X), 8]);
for i=1:8
    for k=1:8
        XLBP(:,:,i) = XLBP(:,:,i)+Xf{k}*2^j(k);
    end
    j = circshift(j,[1 1]);
end
[Y,~] = nanmin(XLBP,[],3);

end