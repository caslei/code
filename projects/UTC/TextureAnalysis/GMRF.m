% /***********************************************************************
%  * AUTHOR: Benhur Ortiz Jaramillo
%  * DATE:  08/06/2011
%  * NAME: GMRF
%  * X. INPUT: Gray Scale Image of size WxH
%  * alpha. OUPUT: GMRF model Parameters
%  * DESCRIPTION: Computes the estimation of GMRF parameters proposed by
%    RChellappa85, Two-dimensional discrete Gaussian-Markov random field
%    models for image processing
%  ***********************************************************************

function a = GMRF(X,varargin)

if size(X,3) > 1
    X = rgb2gray(X);
end
X = mat2gray(X,[0,255]);
X = (X - nanmean(X(:)))/nanstd(X(:));
Sxy = cell(1,6);
H = [0 0 0 0 0; 0 0 1 0 0; 0 0 0 0 0; 0 0 1 0 0; 0 0 0 0 0];
Sxy{1} = filter2(H,X,'valid');
H = [0 0 0 0 0; 0 0 0 0 0; 0 1 0 1 0; 0 0 0 0 0; 0 0 0 0 0];
Sxy{2} = filter2(H,X,'valid');
H = [0 0 1 0 0; 0 0 0 0 0; 0 0 0 0 0; 0 0 0 0 0; 0 0 1 0 0];
Sxy{3} = filter2(H,X,'valid');
H = [0 0 0 0 0; 0 0 0 0 0; 1 0 0 0 1; 0 0 0 0 0; 0 0 0 0 0];
Sxy{4} = filter2(H,X,'valid');
H = [0 0 0 0 0; 0 0 0 1 0; 0 0 0 0 0; 0 1 0 0 0; 0 0 0 0 0];
Sxy{5} = filter2(H,X,'valid');
H = [0 0 0 0 0; 0 1 0 0 0; 0 0 0 0 0; 0 0 0 1 0; 0 0 0 0 0];
Sxy{6} = filter2(H,X,'valid');
H = [0 0 0 0 0; 0 0 0 0 0; 0 0 1 0 0; 0 0 0 0 0; 0 0 0 0 0];
X = filter2(H,X,'valid');
S = zeros(6,6);
G = zeros(6,1);
for i=1:6
    for j=1:6
        S(i,j) = nansum(Sxy{i}(:).*Sxy{j}(:));
    end
    G(i) = nansum(X(:).*Sxy{i}(:));
end
alpha = S\G;
Xhat = zeros(size(X));
for i=1:6
    Xhat = Xhat + alpha(i)*Sxy{i};
end
sigma = (1/((size(X,1)-2)*(size(X,2)-2)))*nansum((X(:)-Xhat(:)).^2);
alpha(end+1) = sigma;
alpha = alpha';

if isempty(varargin)
	a = alpha;
else
    a = alpha(varargin{1});
end

end