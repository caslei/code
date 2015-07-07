% /***********************************************************************
%  * AUTHOR: Benhur Ortiz Jaramillo
%  * DATE:  03/12/2012
%  * NAME: SpatSalMap
%  * I. INPUT: Intensity image
%  * N. INPUT: Size of the block
%  * C. OUPUT: Probability of detecting movement in a block
%  * DESCRIPTION: Computes local contras within a neighbor of size NxN and
%    then apply a psychometric function to estimated the probability of
%    seen movement under that contrast (contrast is computed using entropy)
%  ***********************************************************************

function C = SpatSalMap(I,N)

I = mat2gray(I,[0 255]);
H = ones(N,N);
S = entropyfilt(I,H);
M = log2(N*N);
C = S./M;
beta = 3.163335492; alpha = 0.581768988;
gamma = 0.094765017; lambda = 0;
C = gamma+(1-gamma-lambda).*(1-exp(-(C/alpha).^beta));