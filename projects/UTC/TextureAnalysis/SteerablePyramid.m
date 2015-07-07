% /***********************************************************************
%  * AUTHOR: Benhur Ortiz Jaramillo
%  * DATE:  13/04/2011
%  * NAME: SteerablePyramidFeatures
%  * X. INPUT: Gray Scale Image of size WxH
%  * e. OUPUT: energy from each band of the Steerable Pyramid
%  * DESCRIPTION: Computes the energy over Steerable Pyramid 
%    Space as proposed by WFreeman91 in The Design and Use of Steerable 
%    Filters
%  ***********************************************************************

function e = SteerablePyramid(X,varargin)

if size(X,3) > 1
    X = rgb2gray(X);
end
X = mat2gray(X,[0,255]);
s = 1;
sigma = 1;
G = fspecial('gaussian',[7 7],sigma);
[Gx, Gy] = gradient(G);
theta = [0 45 90 135];
em = [];
for i=1:s
    Xx = filter2(Gx,X,'valid');
    Xy = filter2(Gy,X,'valid');
    for j=1:length(theta)
        Xt = cosd(theta(j))*Xx + sind(theta(j))*Xy;
        em = [nanmean(abs(Xt(:))), nanstd(abs(Xt(:)))];
    end
    X = filter2(G,X,'valid');
    X = X(1:2:end,1:2:end);
end

if isempty(varargin)
	e = em;
else
    e = em(varargin{1});
end

end
