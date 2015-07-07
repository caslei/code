% /***********************************************************************
%  * AUTHOR: Benhur Ortiz Jaramillo
%  * DATE:  08/04/2011
%  * NAME: PowerSpectrumFeatures
%  * X. INPUT: Gray Scale Image of size WxH
%  * e. OUPUT: Compute the response of the ring and wedge filters in
%    Fourier space
%  * DESCRIPTION: Performs the Fourier Transform and then computes the
%    response of the ring and wedge filter theta in steps of 45� and r in
%    steps of pow2 proposed by JWeszka76 in A Comparative Study of Texture
%    Measures for Terrain Classification 
%  ***********************************************************************

function Xp = PowerSpectrum(X,varargin)

if size(X,3) > 1
    X = rgb2gray(X);
end
X = mat2gray(X,[0,255]);
Xp = zeros(size(X,1),size(X,2),10);
XFFT = fft2(ifftshift(X));
XFFTo = fftshift(XFFT);
XFFT = abs(fftshift(XFFT)).^2;
xc = size(XFFT,1)/2+1;
yc = size(XFFT,2)/2+1;
r = [2 4 8 16 32 64; 4 8 16 32 64 128];
theta1 = [112.5 67.5 22.5 157.5; 67.5 22.5 337.5 112.5];
theta2 = [247.5 247.5 202.5 292.5; 292.5 202.5 157.5 337.5];
phi = 0:360;
for i=1:size(r,2)
    xi = xc + r(1,i)*sind(phi);
    yi = yc + r(1,i)*cosd(phi);
    BWi = roipoly(XFFT,yi,xi);
    xi = xc + r(2,i)*sind(phi);
    yi = yc + r(2,i)*cosd(phi);
    BWe = roipoly(XFFT,yi,xi);
    BW = BWe-BWi;
    Xp(:,:,i) = real(fftshift(ifft2(ifftshift(BW.*XFFTo))));
end
rho = 128;
for i=1:size(theta1,2)
    xi = xc + rho*sind(theta1(1,i));
    yi = yc + rho*cosd(theta1(1,i));
    xi = [xi(1,1:end) xc+rho*sind(theta1(2,i)) xc];
    yi = [yi(1,1:end) yc+rho*cosd(theta1(2,i)) yc];
    BW1 = roipoly(XFFT,yi,xi);
    xi = xc + rho*sind(theta2(1,i));
    yi = yc + rho*cosd(theta2(1,i));
    xi = [xi(1,1:end) xc+rho*sind(theta2(2,i)) xc];
    yi = [yi(1,1:end) yc+rho*cosd(theta2(2,i)) yc];
    BW2 = roipoly(XFFT,yi,xi);
    BW = BW1+BW2;
    Xp(:,:,size(r,2)+i) = real(fftshift(ifft2(ifftshift(BW.*XFFTo))));
end