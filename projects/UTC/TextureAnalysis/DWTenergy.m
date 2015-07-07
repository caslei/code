% /***********************************************************************
%  * AUTHOR: Benhur Ortiz Jaramillo
%  * DATE:  12/04/2011
%  * NAME: DWTenergy
%  * X. INPUT: Gray Scale Image of size WxH
%  * e. OUPUT: energy measures of the DWT coefficients
%  * DESCRIPTION: Computes the energy of the DWT coefficients
%  ***********************************************************************

function e = DWTenergy(X,varargin)

if size(X,3) > 1
    X = rgb2gray(X);
end
X = mat2gray(X,[0,255]);
s = 1;
[C,S] = wavedec2(X,s,'haar');
level = size(S,1)-2;
Ca = C(1:prod(S(1,:)));
Ea = [mean2(abs(Ca)), std2(abs(Ca))];
Eh = zeros(1,2*level); Ev = Eh; Ed = Eh;
for k=1:level 
    [Ch,Cv,Cd] = detcoef2('all',C,S,k);
    Eh(2*k-1:2*k) = [mean2(abs(Ch)), std2(abs(Ch))];
    Ev(2*k-1:2*k) = [mean2(abs(Cv)), std2(abs(Cv))]; 
    Ed(2*k-1:2*k) = [mean2(abs(Cd)), std2(abs(Cd))]; 
end
em = [Ea, Eh, Ev, Ed];
if isempty(varargin)
	e = em;
else
    e = em(varargin{1});
end

end