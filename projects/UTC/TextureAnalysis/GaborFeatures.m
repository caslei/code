% /***********************************************************************
%  * AUTHOR: Benhur Ortiz Jaramillo
%  * DATE:  12/04/2011
%  * NAME: GaborFeatures
%  * X. INPUT: Input image
%  * e. OUPUT: energy measures of the the Gabor filtered images
%  * DESCRIPTION: Design a set of Gabor Filters as proposed by BManjunath96
%    Texture Features for Browsing and Retrieval of Image Data
%    in this paper Uh = 0.4, Ul=0.05, K=6 and S = 4
%  ***********************************************************************

function Xp = GaborFeatures(X)

if size(X,3) > 1
    X = rgb2gray(X);
end
X = mat2gray(X,[0,255]);
Uh = 0.4; Ul = 0.05; K = 6; S = 4;
% Parameters proposed in BManjunath96 (See Reference)
W = Uh; nstds = 3; a = (Uh/Ul)^(1/(S-1));
sigmau = ((a-1)*Uh)/((a+1)*sqrt(2*log(2)));
fac1 = tan(pi/(2*K));
fac2 = Uh-2*log((2*sigmau^2)/Uh);
fac3 = (2*log(2)-(((2*log(2))^2)*(sigmau^2)/(Uh^2)))^(-0.5);
sigmav = fac1*fac2*fac3; sigmax = 1/(2*pi*sigmau);
sigmay = 1/(2*pi*sigmav);
xmax = max(abs(nstds*sigmax),abs(nstds*sigmay));
xmax = ceil(max(1,xmax));
ymax = max(abs(nstds*sigmax),abs(nstds*sigmay));
ymax = ceil(max(1,ymax));
xmin = -xmax; ymin = -ymax;
[x,y] = meshgrid(xmin:xmax,ymin:ymax);
fac1 = 1/(2*pi*sigmax*sigmay);
% Filtering Process
Xp = zeros(size(X,1),size(X,2),K*S);
c=1;
for i=0:K-1
    theta = (i*pi)/K;
    for j=0:S-1
        xprime = (a^(-j))*(x*cos(theta)+y*sin(theta));
        yprime = (a^(-j))*(-x*sin(theta)+y*cos(theta));
        fac2 = ((xprime.^2)/(sigmax^2))+((yprime.^2)/(sigmay^2));
        F = (a^(-j))*fac1*exp(-0.5*fac2+2*pi*sqrt(-1)*W*xprime);
        F = F - mean2(F);
        Fi = imag(F);
        Fr = real(F);
        Yi = SymmetricFilter2(X,Fi);
        Yr = SymmetricFilter2(X,Fr);
        Y = sqrt(Yi.*Yi + Yr.*Yr);
		Xp(:,:,c) = Y;
		c = c+1;
    end
end


end

function Y = SymmetricFilter2(X,H)

X = padarray(X,floor(size(H)/2),'symmetric','both');
Y = filter2(H,X,'valid');

end
