% /***********************************************************************
%  * AUTHOR: Benhur Ortiz Jaramillo
%  * DATE:  08/04/2011
%  * NAME: AutoCorr2D
%  * X. INPUT: Gray Scale Image of size WxH
%  * p. OUPUT: Compute parametric features from autocorrelation function
%  * DESCRIPTION: Computes the autocorrelation function and then computes
%    parameters using LS proposed in MPetrou06-Image Processing Dealing 
%    With Texture
%  ***********************************************************************
function p = AutoCorr2D(X,varargin)

if size(X,3) > 1
    X = rgb2gray(X);
end
X = mat2gray(X,[0,255]);
Rho = ifft2(fft2(X).*conj(fft2(X)));
Rho = fftshift(Rho);
Rho = Rho/sum(X(:).*X(:));
S = floor(size(Rho)/2);
[xgrid, ygrid] = ndgrid(-S(2):S(2),-S(1):S(1));
xx = xgrid(:).*xgrid(:); yy = ygrid(:).*ygrid(:); 
xy = xgrid(:).*ygrid(:); x = xgrid(:); y = ygrid(:); 
c = ones(size(xx)); 
r = Rho(:);
A = [xx yy xy x y c];
pm = (A\r)';

if isempty(varargin)
	p = pm;
else
    p = pm(varargin{1});
end

end