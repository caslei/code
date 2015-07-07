% /***********************************************************************
%  * AUTHOR: Benhur Ortiz Jaramillo
%  * DATE:  08/04/2011
%  * NAME: LaplacianPyramidFeatures
%  * X. INPUT: Gray Scale Image of size WxH
%  * e. OUPUT: energy measures from Laplacian Pyramid
%  * DESCRIPTION: Computes the energy measures over Laplacian Pyramid 
%    Space as proposed by PBurt83 in The Laplacian Pyramid as a Compact
%    Image Code
%  ***********************************************************************

function e = LaplacianPyramid(X,varargin)

if size(X,3) > 1
    X = rgb2gray(X);
end
X = mat2gray(X,[0,255]);
s = 1;
sigma = 1;
H = zeros(7,7);
H(4,4) = 1;
G = fspecial('gaussian',[7 7],sigma);
em = [];
for i=1:s
    Y = X;
    X = filter2(G,X,'valid');
    Y = filter2(H,Y,'valid') - X;
    em = [em(1:end), nanmean(abs(Y(:))), nanstd(abs(Y(:)))];
    X = X(1:2:end,1:2:end);
end

if isempty(varargin)
	e = em;
else
    e = em(varargin{1});
end

end
