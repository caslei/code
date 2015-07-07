% /***********************************************************************
%  * AUTHOR: Benhur Ortiz Jaramillo
%  * DATE:  08/04/2011
%  * NAME: AR2D
%  * X. INPUT: Gray Scale or RGB Image of size WxH
%  * ar. OUPUT: AR model Parameters
%  * DESCRIPTION: Computes the estimation of AR parameters proposed by
%    JMao92 in Texture Classification and Segmentation Using 
%    Multiresolution Simultaneous Autoregressive Models
%    X(n,m) = sum i=1:3 sum j=1:3 c((i-1)*3+j)*X(n-i,m-j)
%  ***********************************************************************

function a = AR2D(X,varargin)

if size(X,3) > 1
    X = rgb2gray(X);
end
X = mat2gray(X,[0,255]);
X = (X - nanmean(X(:)))/nanstd(X(:));
H = [0 0 0; 0 1 0; 0 0 0]; x = filter2(H,X,'valid'); x = x(:);
r = sqrt(2)/2;
a = (1-r)*(1-r);
b = r*(1-r);
c = r*(1-r);
d = r*r;
H = [a b 0; c d 0; 0 0 0]; x1 = filter2(H,X,'valid'); x1 = x1(:);
H = [0 1 0; 0 0 0; 0 0 0]; x2 = filter2(H,X,'valid'); x2 = x2(:);
H = [0 a b; 0 c d; 0 0 0]; x3 = filter2(H,X,'valid'); x3 = x3(:);
H = [0 0 0; 0 0 1; 0 0 0]; x4 = filter2(H,X,'valid'); x4 = x4(:);
H = [0 0 0; 0 a b; 0 c d]; x6 = filter2(H,X,'valid'); x6 = x6(:);
H = [0 0 0; 0 0 0; 0 1 0]; x7 = filter2(H,X,'valid'); x7 = x7(:);
H = [0 0 0; a b 0; c d 0]; x8 = filter2(H,X,'valid'); x8 = x8(:);
H = [0 0 0; 1 0 0; 0 0 0]; x9 = filter2(H,X,'valid'); x9 = x9(:);
Z = [x1 x2 x3 x4 x6 x7 x8 x9];
[r,~] = find(isnan(Z));
Z(r,:) = [];
x(r,:) = [];
ar = (Z\x)';
if isempty(varargin)
	a = ar;
else
    a = ar(varargin{1});
end

end