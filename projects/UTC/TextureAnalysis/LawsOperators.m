% /***********************************************************************
%  * AUTHOR: Benhur Ortiz Jaramillo
%  * DATE:  08/04/2011
%  * NAME: LawsOperatorsFeatures
%  * X. INPUT: Gray Scale Image of size WxH
%  * F. OUPUT: Spectral Histogram of the images filtered with the
%    Laws operators
%  * DESCRIPTION: Computes the Spectral Histogram proposed by XLiu03 in
%    Texture Classification Using Spectral Histograms in the Laws space 
%    proposed by KLaws80 in Textured Image Segmentation
%  ***********************************************************************

function Xp = LawsOperators(X)

if size(X,3) > 1
    X = rgb2gray(X);
end
X = mat2gray(X,[0,255]);
L{1} = [1 4 6 4 1]; %L5
L{2} = [-1 -2 0 2 1]; %E5
L{3} = [-1 0 2 0 -1]; %S5 
L{4} = [-1 2 0 -2 1]; %W5
L{5} = [1 -4 6 -4 1]; %R5
H = ones(15,15);
Laws = cell(5,5);
for i=1:5
    for j=1:5
        G = conv2(L{i}',L{j});
        Laws{i,j} = filter2(G,X,'same');
        Laws{i,j} = Laws{i,j}.*Laws{i,j};
        Laws{i,j} = sqrt(filter2(H,Laws{i,j},'same'));
        if i~=1 || j~=1
            Laws{i,j} = Laws{i,j}./Laws{1,1};
        end
    end
end
Xp = zeros(size(X,1),size(X,2),10);
c=1;
for i=1:5
    for j=i+1:5
        LE = Laws{i,j} + Laws{j,i};
        Xp(:,:,c) = abs(LE);
        c=c+1;
    end
end

end