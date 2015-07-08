function dist = hausdorffSuperPixel(a, b,option)
%%% HAUSDORFF: Compute the non-symmetrical Hausdorff distance between two point clusters 
%%%            in an arbitrary dimensional vector space.
%%%            h(A,B) = max(min(d(a,b))), for all a in A, b in B,
%%%            where d(a,b) is a L2 norm.
%%%            or h(A,B) = mean(min(d(a,b)))
%%%   dist = hausdorff( A, B )
%%%     A: the rows of this matrix correspond to points of the ground truth
%%%     contour
%%%     B: the rows of this matrix correspond to the contour points of the
%%%     superpixels
%%%     A and B may have different number of points
%%%     A an B must be either complex vectors or matrices of dimension n,2
%%%     option desides if the regular(option==0(default)) or the modified(option==1)
%%%     is calculated
%%%   Jonas De Vylder  -  Image Processing and Interpretation group
%%%             Ghent University  



   if( size(a,2) >2 || size(b,2)>2 )
      fprintf( 'WARNING: A an B must be either complex vectors or matrices of dimension n,2 \n' );
      dist = [];
      return;
   end
    a=mat2vec(a);
    b=mat2vec(b);
    
    [A,B]=meshgrid(a,b);
    
    D = A-B;
    
    D= sqrt(real(D).^2+imag(D).^2);
    if(option==0)
        h1=max(min(D));
        h2=max(min(D,[],2));
    elseif(option==1)
        h1=sum(min(D))/size(a,1);
        h2=sum(min(D,[],2))/size(b,1);
    else
        fprintf( 'WARNING: option must be 0(regular haufsdorff distance) or 1(modified hasdorff distance \n');
        h1=0;
        h2=0;
    end
%     dist=max(h1,h2);
   dist=h1;
end


function vec = mat2vec(mat)
%%% converts a matrix with 2 colums to a complex vector

if (size(mat,2)==2)
    vec=mat(:,1)+i*mat(:,2);
else
    vec=mat;
end
end