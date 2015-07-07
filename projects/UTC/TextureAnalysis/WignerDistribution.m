% /***********************************************************************
%  * AUTHOR: Benhur Ortiz Jaramillo
%  * DATE:  08/04/2011
%  * NAME: WignerDistribution
%  * X. INPUT: Gray Scale Image of size WxH
%  * N. INPUT: Window size to compute the Wigner Distribution 3,5,...,(15) 
%  * e. OUPUT: energy of each Wigner Distribution
%  * DESCRIPTION: Compute the Wigner Pseudo-Distribution proposed by
%    GCristobal91 in Image filtering and analysis through the Wigner
%    Distribution and extract the energy of each band
%  ***********************************************************************

function Xp = WignerDistribution(X)

if size(X,3) > 1
    X = rgb2gray(X);
end
X = mat2gray(X,[0,255]);
N = 3;
M1 = zeros(size(X,1),size(X,2),N,N);
M2 = zeros(size(X,1),size(X,2),N,N);
M  = zeros(size(X,1),size(X,2),N,N);
W  = zeros(size(X,1),size(X,2),N,N);
lim = floor(N/2);
H = fspecial('gaussian',[7 7],1);
G = fspecial('gaussian',[N N],N/6);
for i=-lim:lim
    for j=-lim:lim
        m = zeros(N,N);
        m(i+lim+1,j+lim+1) = 1;
        M1(:,:,i+lim+1,j+lim+1) = SymmetricFilter2(X,m);
        m = zeros(N,N);
        m(-i+lim+1,-j+lim+1) = 1;
        M2(:,:,i+lim+1,j+lim+1) = SymmetricFilter2(X,m);
        M(:,:,i+lim+1,j+lim+1) = M1(:,:,i+lim+1,j+lim+1)...
                                .*M2(:,:,i+lim+1,j+lim+1);
        M(:,:,i+lim+1,j+lim+1) = SymmetricFilter2(...
                                 M(:,:,i+lim+1,j+lim+1),H);                 
    end
end
for i=1:size(X,1)
    for j=1:size(X,2)
        T = reshape(M(i,j,:,:),N,N);
        T = abs(fftshift(fft2(ifftshift(T.*G)))).^2;
        W(i,j,:,:) = reshape(T,1,1,N,N);
        W(i,j,:,:) = W(i,j,:,:);
    end
end
W = W*(sum(X(:).*X(:))/sum(W(:)));
Xp = cell(1,N*N);
c=1;
for i=-lim:lim
    for j=-lim:lim
        T = W(:,:,i+lim+1,j+lim+1);
		Xp{c}=T;
		c=c+1;
    end
end

end

function Y = SymmetricFilter2(X,H)

X = padarray(X,floor(size(H)/2),'symmetric','both');
Y = filter2(H,X,'valid');

end