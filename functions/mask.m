
% Draws a mask M on an image V
function RGB = mask(V,M)

V=V-min(V(:));
V=V/max(V(:));
V=.25+0.75*V;

M=M-min(M(:));
M=M/max(M(:));

H=0.0+zeros(size(V));
S=M;

RGB = hsv2rgb(H,S,V);

end