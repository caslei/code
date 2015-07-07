
% img = imread3D('/net/ipi/scratch/jbroels/microct/reconstructed2/stack.tif');

im = squeeze(img(200,:,:));

% figure,imshow(im,[])
T = 7000;
im2 = im;
im2(im<T) = 0;
% figure,imshow(im2,[]);

filter_l = fspecial('average');
filter_h = fspecial('prewitt');
filter_v = filter_h';

im_l = imfilter(im2,filter_l);
im_h = imfilter(im2,filter_h);
im_v = imfilter(im2,filter_v);
% figure,imshow(im_l,[]);
% figure,imshow(im_h,[]);
% figure,imshow(im_v,[]);

n_l_lines = 5;
n_h_lines = 5;
n_v_lines = 5;
figure; imshow(im2,[]);

disp(['Please annotate ' num2str(n_l_lines) ' background regions. ']);
l_coos = [];
for i=1:n_l_lines
    h = imfreehand(gca,'Closed',0);
    setColor(h,[0,1,0]);
    l_coos = [l_coos; round(getPosition(h))];
end

disp(['Please annotate ' num2str(n_h_lines) ' horizontally textured regions. ']);
h_coos = [];
for i=1:n_h_lines
    h = imfreehand(gca,'Closed',0);
    setColor(h,[0,1,0]);
    h_coos = [h_coos; round(getPosition(h))];
end

disp(['Please annotate ' num2str(n_v_lines) ' vertically textured regions. ']);
v_coos = [];
for i=1:n_v_lines
    h = imfreehand(gca,'Closed',0);
    setColor(h,[0,1,0]);
    v_coos = [v_coos; round(getPosition(h))];
end

l_selection = zeros(size(im2));
for i=1:size(l_coos,1)
    l_selection(l_coos(i,2),l_coos(i,1)) = 1;
end
l_selection = logical(l_selection);

h_selection = zeros(size(im2));
for i=1:size(h_coos,1)
    h_selection(h_coos(i,2),h_coos(i,1)) = 1;
end
h_selection = logical(h_selection);

v_selection = zeros(size(im2));
for i=1:size(v_coos,1)
    v_selection(v_coos(i,2),v_coos(i,1)) = 1;
end
v_selection = logical(v_selection);

figure,imshow(l_selection,[]);
figure,imshow(h_selection,[]);
figure,imshow(v_selection,[]);

% Extract three features: low-pass, horizontal en vertical prewitt filter:
l_features = [im_l(l_selection), im_h(l_selection), im_v(l_selection)];
l_ones = ones(size(l_features,1),1);
h_features = [im_l(h_selection), im_h(h_selection), im_v(h_selection)];
h_ones = ones(size(h_features,1),1);
v_features = [im_l(v_selection), im_h(v_selection), im_v(v_selection)];
v_ones = ones(size(v_features,1),1);

[coeff,score,latent] = pca([l_features;h_features;v_features]);

% Train SVM classifier
svm_l = fitcsvm([l_features;h_features;v_features],[l_ones*1   ;h_ones*(-1);v_ones*(-1)]);
svm_h = fitcsvm([l_features;h_features;v_features],[l_ones*(-1);h_ones*1   ;v_ones*(-1)]);
svm_v = fitcsvm([l_features;h_features;v_features],[l_ones*(-1);h_ones*(-1);v_ones*1]);
