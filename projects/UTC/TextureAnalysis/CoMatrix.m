% /***********************************************************************
%  * AUTHOR: Benhur Ortiz Jaramillo
%  * DATE:  08/04/2011
%  * NAME: CoMatrix
%  * X. INPUT: Gray Scale Image of size WxH
%  * c. OUPUT: Features from the Coocurrence matrix c = [s.Energy, 
%      s.Contrast, s.Correlation, variance, s.Homogeneity, Entropy, 
%      info1, info2];
%  * DESCRIPTION: Computes the most used features from Coocurrence matrix
%    Proposed by RHaralick79 in Statistical and Structural Approaches to
%    Texture
%  ***********************************************************************

function c = CoMatrix(X,varargin)

if size(X,3) > 1
    X = rgb2gray(X);
end
X = mat2gray(X,[0,255]);
D = [0 1; -1 1; -1 0; -1 -1];
GLCM = zeros(64,64);
for i=1:4
    GLCM = GLCM + graycomatrix(X,'Offset',D(i,:),'NumLevels',64);
end
GLCM = round(GLCM/4);
s = graycoprops(GLCM);
GLCM = GLCM/sum(sum(GLCM));
GLCM(GLCM==0) = eps;
[igrid, ~] = meshgrid(1:64,1:64);
variance = sum(sum(((igrid-mean2(GLCM)).^2).*GLCM));
Entropy = -sum(sum(GLCM.*log2(GLCM)));
GLCMx = sum(GLCM,1); GLCMy = sum(GLCM,2);
Ex = -sum(sum(GLCMx.*log2(GLCMx)));
Ey = -sum(sum(GLCMy.*log2(GLCMy)));
GLCMx = repmat(GLCMx,64,1);
GLCMy = repmat(GLCMy,1,64);
Hxy1 = -sum(sum(GLCM.*log2(GLCMx.*GLCMy)));
info1 = (Entropy-Hxy1)/max(Ex,Ey);
Hxy2 = -sum(sum((GLCMx.*GLCMy).*log2(GLCMx.*GLCMy)));
info2 = sqrt(1-exp(-2*(Hxy2-Entropy)));
cm = [s.Energy, s.Contrast, s.Correlation, variance, s.Homogeneity,...
     Entropy, info1, info2];
if isempty(varargin)
	c = cm;
else
    c = cm(varargin{1});
end
 
end