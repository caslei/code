% computes the probability maps for a set of image features with a given
% kernel density estimation
function pms = compute_pms(img_features, ksd_xs, ksd_fs)

n_features = size(ksd_xs,1);
n_classes = size(ksd_xs,2);

pms = zeros(size(img_features,1),size(img_features,2),n_features,n_classes);

for nf = 1:n_features
    for nc = 1:n_classes
        pms(:,:,nf,nc) = compute_pm(img_features(:,:,nf),ksd_xs{nf,nc},ksd_fs{nf,nc});
    end
end

end

function pm = compute_pm(img,ksd_x,ksd_f)
    temp = repmat(img,1,1,length(ksd_x));
    temp = abs(temp - permute(repmat(ksd_x,size(img,1),1,size(img,2)),[1,3,2]));
    [~,I] = min(temp,[],3);
    pm = ksd_f(I);
end