
% im = imread3D('C:\Users\Joris\Documents\PhD\matlab\data\microct\reconstructed2\stack.tif');
load im.mat
% im = squeeze(img(200,:,:));

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
im_sh = stdfilt(im_h);
im_sv = stdfilt(im_v);
% figure,imshow(im_l,[]);
% figure,imshow(im_h,[]);
% figure,imshow(im_v,[]);
% figure,imshow(im_sh,[]);
% figure,imshow(im_sv,[]);

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
    setColor(h,[1,0,0]);
    h_coos = [h_coos; round(getPosition(h))];
end

disp(['Please annotate ' num2str(n_v_lines) ' vertically textured regions. ']);
v_coos = [];
for i=1:n_v_lines
    h = imfreehand(gca,'Closed',0);
    setColor(h,[0,0,1]);
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

% figure,imshow(l_selection,[]);
% figure,imshow(h_selection,[]);
% figure,imshow(v_selection,[]);

% Estimate kernel smoothing functions: XY_ksd_f expresses the probability
% that feature outcome X of a pixel corresponds to pixel class Y
disp('Training model ...');
disp('    Computing kernel smoothing functions ...');
[ll_ksd_f, ll_ksd_x]   = ksdensity(im_l(l_selection));  % lowpass features of the trained background samples
[lh_ksd_f, lh_ksd_x]   = ksdensity(im_l(h_selection));  % lowpass features of the trained horizontal samples
[lv_ksd_f, lv_ksd_x]   = ksdensity(im_l(v_selection));  % lowpass features of the trained vertical samples

[hl_ksd_f, hl_ksd_x]   = ksdensity(im_h(l_selection));  % horizontal prewitt features of the trained background samples
[hh_ksd_f, hh_ksd_x]   = ksdensity(im_h(h_selection));  % horizontal prewitt features of the trained horizontal samples
[hv_ksd_f, hv_ksd_x]   = ksdensity(im_h(v_selection));  % horizontal prewitt features of the trained vertical samples

[vl_ksd_f, vl_ksd_x]   = ksdensity(im_v(l_selection));  % vertical prewitt features of the trained background samples
[vh_ksd_f, vh_ksd_x]   = ksdensity(im_v(h_selection));  % vertical prewitt features of the trained horizontal samples
[vv_ksd_f, vv_ksd_x]   = ksdensity(im_v(v_selection));  % vertical prewitt features of the trained vertical samples

[shl_ksd_f, shl_ksd_x] = ksdensity(im_sh(l_selection)); % horizontal std features of the trained background samples
[shh_ksd_f, shh_ksd_x] = ksdensity(im_sh(h_selection)); % horizontal std features of the trained horizontal samples
[shv_ksd_f, shv_ksd_x] = ksdensity(im_sh(v_selection)); % horizontal std features of the trained vertical samples

[svl_ksd_f, svl_ksd_x] = ksdensity(im_sv(l_selection)); % vertical std features of the trained background samples
[svh_ksd_f, svh_ksd_x] = ksdensity(im_sv(h_selection)); % vertical std features of the trained horizontal samples
[svv_ksd_f, svv_ksd_x] = ksdensity(im_sv(v_selection)); % vertical std features of the trained vertical samples

% normalize
ll_ksd_f  = ll_ksd_f/sum(ll_ksd_f);
lh_ksd_f  = lh_ksd_f/sum(lh_ksd_f);
lv_ksd_f  = lv_ksd_f/sum(lv_ksd_f);

hl_ksd_f  = hl_ksd_f/sum(hl_ksd_f);
hh_ksd_f  = hh_ksd_f/sum(hh_ksd_f);
hv_ksd_f  = hv_ksd_f/sum(hv_ksd_f);

vl_ksd_f  = vl_ksd_f/sum(vl_ksd_f);
vh_ksd_f  = vh_ksd_f/sum(vh_ksd_f);
vv_ksd_f  = vv_ksd_f/sum(vv_ksd_f);

shl_ksd_f = shl_ksd_f/sum(shl_ksd_f);
shh_ksd_f = shh_ksd_f/sum(shh_ksd_f);
shv_ksd_f = shv_ksd_f/sum(shv_ksd_f);

svl_ksd_f = svl_ksd_f/sum(svl_ksd_f);
svh_ksd_f = svh_ksd_f/sum(svh_ksd_f);
svv_ksd_f = svv_ksd_f/sum(svv_ksd_f);

% plot estimates
figure;
subplot(3,5,1);
plot(ll_ksd_x,ll_ksd_f); title('L-L KSD'); xlim([0 20000]);
subplot(3,5,6);
plot(lh_ksd_x,lh_ksd_f); title('L-H KSD'); xlim([0 20000]);
subplot(3,5,11);
plot(lv_ksd_x,lv_ksd_f); title('L-V KSD'); xlim([0 20000]);

subplot(3,5,2);
plot(hl_ksd_x,hl_ksd_f); title('H-L KSD'); xlim([-40000 40000]);
subplot(3,5,7);
plot(hh_ksd_x,hh_ksd_f); title('H-H KSD'); xlim([-40000 40000]);
subplot(3,5,12);
plot(hv_ksd_x,hv_ksd_f); title('H-V KSD'); xlim([-40000 40000]);

subplot(3,5,3);
plot(vl_ksd_x,vl_ksd_f); title('V-L KSD'); xlim([-40000 40000]);
subplot(3,5,8);
plot(vh_ksd_x,vh_ksd_f); title('V-H KSD'); xlim([-40000 40000]);
subplot(3,5,13);
plot(vv_ksd_x,vv_ksd_f); title('V-V KSD'); xlim([-40000 40000]);

subplot(3,5,4);
plot(shl_ksd_x,shl_ksd_f); title('SH-L KSD'); xlim([0 25000]);
subplot(3,5,9);
plot(shh_ksd_x,shh_ksd_f); title('SH-H KSD'); xlim([0 25000]);
subplot(3,5,14);
plot(shv_ksd_x,shv_ksd_f); title('SH-V KSD'); xlim([0 25000]);

subplot(3,5,5);
plot(svl_ksd_x,svl_ksd_f); title('SV-L KSD'); xlim([0 25000]);
subplot(3,5,10);
plot(svh_ksd_x,svh_ksd_f); title('SV-H KSD'); xlim([0 25000]);
subplot(3,5,15);
plot(svv_ksd_x,svv_ksd_f); title('SV-V KSD'); xlim([0 25000]);


% construction of the probability maps
disp('    Computing probability maps ...');
imt = im;
imt_l = imfilter(imt,filter_l);
imt_h = imfilter(imt,filter_h);
imt_v = imfilter(imt,filter_v);
imt_sh = stdfilt(imt_h);
imt_sv = stdfilt(imt_v);

% LL
temp = repmat(imt_l,1,1,length(ll_ksd_x));
temp = abs(temp - permute(repmat(ll_ksd_x,size(imt_l,1),1,size(imt_l,2)),[1,3,2]));
[~,I] = min(temp,[],3);
ll_pm = ll_ksd_f(I);
% LH
temp = repmat(imt_l,1,1,length(lh_ksd_x));
temp = abs(temp - permute(repmat(lh_ksd_x,size(imt_l,1),1,size(imt_l,2)),[1,3,2]));
[~,I] = min(temp,[],3);
lh_pm = lh_ksd_f(I);
% LV
temp = repmat(imt_l,1,1,length(lv_ksd_x));
temp = abs(temp - permute(repmat(lv_ksd_x,size(imt_l,1),1,size(imt_l,2)),[1,3,2]));
[~,I] = min(temp,[],3);
lv_pm = lv_ksd_f(I);

% HL
temp = repmat(imt_h,1,1,length(hl_ksd_x));
temp = abs(temp - permute(repmat(hl_ksd_x,size(imt_h,1),1,size(imt_h,2)),[1,3,2]));
[~,I] = min(temp,[],3);
hl_pm = hl_ksd_f(I);
% HH
temp = repmat(imt_h,1,1,length(hh_ksd_x));
temp = abs(temp - permute(repmat(hh_ksd_x,size(imt_h,1),1,size(imt_h,2)),[1,3,2]));
[~,I] = min(temp,[],3);
hh_pm = hh_ksd_f(I);
% HV
temp = repmat(imt_h,1,1,length(hv_ksd_x));
temp = abs(temp - permute(repmat(hv_ksd_x,size(imt_h,1),1,size(imt_h,2)),[1,3,2]));
[~,I] = min(temp,[],3);
hv_pm = hv_ksd_f(I);

% VL
temp = repmat(imt_v,1,1,length(vl_ksd_x));
temp = abs(temp - permute(repmat(vl_ksd_x,size(imt_v,1),1,size(imt_v,2)),[1,3,2]));
[~,I] = min(temp,[],3);
vl_pm = vl_ksd_f(I);
% VH
temp = repmat(imt_v,1,1,length(vh_ksd_x));
temp = abs(temp - permute(repmat(vh_ksd_x,size(imt_v,1),1,size(imt_v,2)),[1,3,2]));
[~,I] = min(temp,[],3);
vh_pm = vh_ksd_f(I);
% VV
temp = repmat(imt_v,1,1,length(vv_ksd_x));
temp = abs(temp - permute(repmat(vv_ksd_x,size(imt_v,1),1,size(imt_v,2)),[1,3,2]));
[~,I] = min(temp,[],3);
vv_pm = vv_ksd_f(I);

% SHL
temp = repmat(imt_sh,1,1,length(shl_ksd_x));
temp = abs(temp - permute(repmat(shl_ksd_x,size(imt_sh,1),1,size(imt_sh,2)),[1,3,2]));
[~,I] = min(temp,[],3);
shl_pm = shl_ksd_f(I);
% SHH
temp = repmat(imt_sh,1,1,length(shh_ksd_x));
temp = abs(temp - permute(repmat(shh_ksd_x,size(imt_sh,1),1,size(imt_sh,2)),[1,3,2]));
[~,I] = min(temp,[],3);
shh_pm = shh_ksd_f(I);
% SHV
temp = repmat(imt_sh,1,1,length(shv_ksd_x));
temp = abs(temp - permute(repmat(shv_ksd_x,size(imt_sh,1),1,size(imt_sh,2)),[1,3,2]));
[~,I] = min(temp,[],3);
shv_pm = shv_ksd_f(I);

% SVL
temp = repmat(imt_sv,1,1,length(svl_ksd_x));
temp = abs(temp - permute(repmat(svl_ksd_x,size(imt_sv,1),1,size(imt_sv,2)),[1,3,2]));
[~,I] = min(temp,[],3);
svl_pm = svl_ksd_f(I);
% SVH
temp = repmat(imt_sv,1,1,length(svh_ksd_x));
temp = abs(temp - permute(repmat(svh_ksd_x,size(imt_sv,1),1,size(imt_sv,2)),[1,3,2]));
[~,I] = min(temp,[],3);
svh_pm = svh_ksd_f(I);
% SVV
temp = repmat(imt_sv,1,1,length(svv_ksd_x));
temp = abs(temp - permute(repmat(svv_ksd_x,size(imt_sv,1),1,size(imt_sv,2)),[1,3,2]));
[~,I] = min(temp,[],3);
svv_pm = svv_ksd_f(I);

% % plot probability maps
% figure;
% subplot(3,5,1);
% imshow(ll_pm,[]); title('L-L'); 
% subplot(3,5,6);
% imshow(lh_pm,[]); title('L-H'); 
% subplot(3,5,11);
% imshow(lv_pm,[]); title('L-V'); 
% 
% subplot(3,5,2);
% imshow(hl_pm,[]); title('H-L'); 
% subplot(3,5,7);
% imshow(hh_pm,[]); title('H-H'); 
% subplot(3,5,12);
% imshow(hv_pm,[]); title('H-V'); 
% 
% subplot(3,5,3);
% imshow(vl_pm,[]); title('V-L'); 
% subplot(3,5,8);
% imshow(vh_pm,[]); title('V-H'); 
% subplot(3,5,13);
% imshow(vv_pm,[]); title('V-V'); 
% 
% subplot(3,5,4);
% imshow(shl_pm,[]); title('SH-L'); 
% subplot(3,5,9);
% imshow(shh_pm,[]); title('SH-H'); 
% subplot(3,5,14);
% imshow(shv_pm,[]); title('SH-V'); 
% 
% subplot(3,5,5);
% imshow(svl_pm,[]); title('SV-L'); 
% subplot(3,5,10);
% imshow(svh_pm,[]); title('SV-H'); 
% subplot(3,5,15);
% imshow(svv_pm,[]); title('SV-V'); 

% combine probability maps to class probabilities
disp('    Combining probability maps to class probabilities ...');
l_params = [1.00 0.05 0.05 0.25 0.25];
h_params = [0.50 0.00 0.35 0.00 0.35];
v_params = [0.50 0.35 0.00 0.35 0.00];

l_prob = l_params(1)*ll_pm + l_params(2)*hl_pm + l_params(3)*vl_pm + l_params(4)*shl_pm + l_params(5)*svl_pm;
l_prob = l_prob/sum(l_params);
h_prob = h_params(1)*lh_pm + h_params(2)*hh_pm + h_params(3)*vh_pm + h_params(4)*shh_pm + h_params(5)*svh_pm;
h_prob = h_prob/sum(h_params);
v_prob = v_params(1)*lv_pm + v_params(2)*hv_pm + v_params(3)*vv_pm + v_params(4)*shv_pm + v_params(5)*svv_pm;
v_prob = v_prob/sum(v_params);

lowpass = fspecial('disk', 10);
% figure, imshow(l_prob,[]);
% figure, imshow(h_prob,[]);
% figure, imshow(v_prob,[]);

% extract segmentation
disp('Extracting segmentation ...');
prob_maps = zeros(size(l_prob,1),size(l_prob,2),3);
prob_maps(:,:,1) = l_prob;
prob_maps(:,:,2) = h_prob;
prob_maps(:,:,3) = v_prob;
[M_S,I_S] = max(prob_maps,[],3);
L = I_S==1;
H = I_S==2;
V = I_S==3;
figure,imshow(L,[]);
figure,imshow(H,[]);
figure,imshow(V,[]);

% figure,imshow(L,[]);
LL = medfilt2(L,[11 11]);
% figure,imshow(LL,[]);
LLL = imclose(LL,strel('disk',3));
% figure,imshow(LLL,[]);
LLLL = imopen(LLL,strel('disk',6));
% figure,imshow(LLLL,[]);
LLLLL = imfill(LLLL,'holes');
% figure,imshow(LLLLL,[]);
LLLLLL = bwareaopen(LLLLL, 1000);
% figure,imshow(LLLLLL,[]);

% figure,imshow(H,[]);
HH = medfilt2(H,[15 15]);
% figure,imshow(HH,[]);
HHH = imopen(HH,strel('disk',7));
% figure,imshow(HHH,[]);
HHHH = imclose(HHH,strel('disk',4));
% figure,imshow(HHHH,[]);
HHHHH = imfill(HHHH,'holes');
% figure,imshow(HHHHH,[]);
HHHHHH = bwareaopen(HHHHH, 2500);
% figure,imshow(HHHHHH,[]);

% figure,imshow(V,[]);
VV = medfilt2(V,[5 5]);
% figure,imshow(VV,[]);
VVV = imclose(VV,strel('disk',7));
% figure,imshow(VVV,[]);
VVVV = imopen(VVV,strel('disk',3));
% figure,imshow(VVVV,[]);
VVVVV = imfill(VVVV,'holes');
% figure,imshow(VVVVV,[]);
VVVVVV = bwareaopen(VVVVV, 2500);
% figure,imshow(VVVVVV,[]);

L_S = LLLLLL;
H_S = HHHHHH;
V_S = VVVVVV;

figure, imshow(uint16(drawmask(im,H_S)));
figure, imshow(uint16(im));
figure, imshow(uint16(drawmask(im,V_S)));
