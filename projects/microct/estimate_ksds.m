% estimates a kernel density function on a set of training data
% the returned values are the density domain points and values for every
% feature and class
function [ksd_fs,  ksd_xs] = estimate_ksds(img_features, selections)

n_features = size(img_features,3);
n_classes = size(selections,3);

ksd_fs = cell(n_features,n_classes);
ksd_xs = cell(n_features,n_classes);

for nf = 1:n_features
    for nc = 1:n_classes
        img_feature = img_features(:,:,nf);
        [ksd_f,  ksd_x] = ksdensity(img_feature(selections(:,:,nc)));
        ksd_f = ksd_f/sum(ksd_f);
        ksd_fs{nf,nc} = ksd_f;
        ksd_xs{nf,nc} = ksd_x;
    end
end

end

