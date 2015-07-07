
clear all;
close all;

img_path = '/net/ipi/scratch/jbroels/microct/reconstructed2/1_0159.tif';
img = imread(img_path);
bg = double(img)<4000;
bg = bwmorph(1-bg,'erode');
bg = bwmorph(bg,'open');
bg = bwmorph(bg,'dilate',5);
bg = logical(1-bwmorph(bg,'erode'));
fg = logical(1-bg);
img(bg) = 0;

n_pos_lines = 5;
n_neg_lines = 5;
figure; imshow(img,[]);
pos_coos = [];
for i=1:n_pos_lines
    h = imfreehand(gca,'Closed',0);
    setColor(h,[0,1,0]);
    pos_coos = [pos_coos; round(getPosition(h))];
end
neg_coos = [];
for i=1:n_neg_lines
    h = imfreehand(gca,'Closed',0);
    setColor(h,[1,0,0]);
    neg_coos = [neg_coos; round(getPosition(h))];
end

pos_selection = zeros(size(img));
for i=1:size(pos_coos,1)
    pos_selection(pos_coos(i,2),pos_coos(i,1)) = 1;
end
pos_selection = logical(pos_selection);
neg_selection = zeros(size(img));
for i=1:size(neg_coos,1)
    neg_selection(neg_coos(i,2),neg_coos(i,1)) = 1;
end
neg_selection = logical(neg_selection);

img = double(img);

% compute features
X = compute_features(img,fg);

% average feature
avg_size = 5;
h_avg = fspecial('average',avg_size);
img_avg = imfilter(img,h_avg);
img_avg(bg) = 0;
% figure; imshow(img_avg,[]);

% gradient features
[img_gx,img_gy] = gradient(img);
img_gx = abs(img_gx);
img_gx(bg) = 0;
img_gy = abs(img_gy);
img_gy(bg) = 0;
% figure; imshow(img_gx,[]);
% figure; imshow(img_gy,[]);

% local standard deviation feature
std_size = 5;
img_std = stdfilt(img, ones(std_size));
img_std(bg) = 0;
% figure; imshow(img_std,[]);

% local range feature (max-min)
rng_size = 5;
img_rng = rangefilt(img, ones(rng_size));
img_rng(bg) = 0;
% figure; imshow(img_rng,[]);

% merge features into training samples
n_train_pos_pixels = nnz(pos_selection);
n_train_neg_pixels = nnz(neg_selection);
n_train_pixels = n_train_pos_pixels + n_train_neg_pixels;
X_train = zeros(n_train_pixels,5);
X_train(:,1) = [img_avg(pos_selection); img_avg(neg_selection)];
X_train(:,2) = [img_gx(pos_selection); img_gx(neg_selection)];
X_train(:,3) = [img_gy(pos_selection); img_gy(neg_selection)];
X_train(:,4) = [img_std(pos_selection); img_std(neg_selection)];
X_train(:,5) = [img_rng(pos_selection); img_rng(neg_selection)];
Y = zeros(n_train_pixels,1);
Y(1:n_train_pos_pixels) = 1;

% train SVM classifier
disp('Training SVM classifier ...');
SVMModel = fitcsvm(X_train,Y);
disp('Done');

% apply pca on training data
[coeff,score,latent] = pca(X_train);
figure(); scatter(score(1:n_train_pos_pixels,1),score(1:n_train_pos_pixels,2),'+');
hold on;
scatter(score(n_train_pos_pixels+1:end,1),score(n_train_pos_pixels+1:end,2));
xlabel('1st Principal Component');
ylabel('2nd Principal Component');
hold off;

% merge features into test samples
n_test_pixels = nnz(fg);
X_test = zeros(n_test_pixels,5);
X_test(:,1) = img_avg(fg);
X_test(:,2) = img_gx(fg);
X_test(:,3) = img_gy(fg);
X_test(:,4) = img_std(fg);
X_test(:,5) = img_rng(fg);

% classify test samples using the trained SVM classifier
disp('Classifying ...');
Y_pred = predict(SVMModel, X_test);
disp('Done');

% construct segmentation mask
seg_mask = zeros(size(img));
seg_mask(fg) = Y_pred;
seg_mask = logical(seg_mask);
figure; imshow(uint16(drawmask(img,seg_mask)));


% alfa1 = 0.5; 
% alfa2 = 0.7; 
% thr = 0.10;
% mask = horizontal_edge_detector(img, alfa1, alfa2, thr);
% figure; imshow(drawmask(uint8(double(img)/2^8),mask)./(2^8-1));
% title(['HORIZONTAL EDGE DETECTOR alfa1=' num2str(alfa1) ', alfa2=' num2str(alfa2) ', thr=' num2str(thr)]);
% 
% 
% alfa = 0.2; 
% thr = 0.4;
% mask = horizontal_line_detector(img, alfa, thr);
% figure,imshow(uint16(drawmask(img,mask)));
% title(['HORIZONTAL LINE DETECTOR alfa=' num2str(alfa) ', thr=' num2str(thr)]);

