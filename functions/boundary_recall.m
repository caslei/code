function b_r = boundary_recall(b_im_sa, b_im_gt, d)
% Computes the boundary recall for a boundary image b_im_sa, the result of a
% segmentation algorithm, and an array of groundtruth boundary images b_im_gt. 

b_im_sa = imdilate(b_im_sa, ones(d,d));

m = ndims(b_im_gt);

if m==2
    % 1 groundtruth image
    TP = nnz(b_im_sa.*b_im_gt);
    FN = nnz((1-b_im_sa).*b_im_gt);
    b_r = TP/(TP+FN);
else if m==3
        % Multiple groundtruth images
        b_im_gt = min(sum(b_im_gt,3),1);
        TP = nnz(b_im_sa.*b_im_gt);
        FN = nnz((1-b_im_sa).*b_im_gt);
        b_r = TP/(TP+FN);
    end
end

end

