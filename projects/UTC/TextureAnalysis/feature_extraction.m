dir = '/ipi/scratch/bortiz/TextureAnalysis/Test_Images/';
name = {'cimi__153_1','cimi__157_1','cimi_S644_1'};
H = zeros(9,9); H(5,5) = 1;
for i=1:length(name)
    I = imread([dir, name{i}, '.tif']);
    I = rgb2gray(I);
    if i~=1
    % AR2D
    Xfeatures = cell(1,8);
    disp('empece\n')
    for j=1:8
        fun = @(x) AR2D(x,j);
        Xfeatures{j} = nlfilter(I, [9 9], fun);
        Xfeatures{j} = filter2(H,Xfeatures{j},'valid');
        imwrite(mat2gray(Xfeatures{j}),[dir, 'temp.png'])
        rgb = ind2rgb(imread([dir, 'temp.png']),jet(256));
        imwrite(rgb,[dir, name{i}, '_AR2D', num2str(j) '.png'])
        disp(['AR2D: ', num2str(i), ' ', num2str(j)])
    end
    save([dir, name{i}, '_AR2D.mat'],'Xfeatures')
    % AutoCorr2D
    Xfeatures = cell(1,6);
    for j=1:6
        fun = @(x) AutoCorr2D(x,j);
        Xfeatures{j} = nlfilter(I, [9 9], fun);
        Xfeatures{j} = filter2(H,Xfeatures{j},'valid');
        imwrite(mat2gray(Xfeatures{j}),[dir, 'temp.png'])
        rgb = ind2rgb(imread([dir, 'temp.png']),jet(256));
        imwrite(rgb,[dir, name{i}, '_AutoCorr2D', num2str(j) '.png'])
        disp(['AutoCorr2D: ', num2str(i), ' ', num2str(j)])
    end
    save([dir, name{i}, '_AutoCorr2D.mat'],'Xfeatures')
    % CoMatrix
    Xfeatures = cell(1,8);
    for j=1:8
        fun = @(x) CoMatrix(x,j);
        Xfeatures{j} = nlfilter(I, [9 9], fun);
        Xfeatures{j} = filter2(H,Xfeatures{j},'valid');
        imwrite(mat2gray(Xfeatures{j}),[dir, 'temp.png'])
        rgb = ind2rgb(imread([dir, 'temp.png']),jet(256));
        imwrite(rgb,[dir, name{i}, '_CoMatrix', num2str(j) '.png'])
        disp(['CoMatrix: ', num2str(i), ' ', num2str(j)])
    end
    save([dir, name{i}, '_CoMatrix.mat'],'Xfeatures')
    % DWTenergy
    Xfeatures = cell(1,8);
    for j=1:8
        fun = @(x) DWTenergy(x,j);
        Xfeatures{j} = nlfilter(I, [9 9], fun);
        Xfeatures{j} = filter2(H,Xfeatures{j},'valid');
        imwrite(mat2gray(Xfeatures{j}),[dir, 'temp.png'])
        rgb = ind2rgb(imread([dir, 'temp.png']),jet(256));
        imwrite(rgb,[dir, name{i}, '_DWTenergy', num2str(j) '.png'])
        disp(['DWTenergy: ', num2str(i), ' ', num2str(j)])
    end
    save([dir, name{i}, '_DWTenergy.mat'],'Xfeatures')
    % GMRF
    Xfeatures = cell(1,7);
    for j=1:7
        fun = @(x) GMRF(x,j);
        Xfeatures{j} = nlfilter(I, [9 9], fun);
        Xfeatures{j} = filter2(H,Xfeatures{j},'valid');
        imwrite(mat2gray(Xfeatures{j}),[dir, 'temp.png'])
        rgb = ind2rgb(imread([dir, 'temp.png']),jet(256));
        imwrite(rgb,[dir, name{i}, '_GMRF', num2str(j) '.png'])
        disp(['GMRF: ', num2str(i), ' ', num2str(j)])
    end
    save([dir, name{i}, '_GMRF.mat'],'Xfeatures')
    % LaplacianPyramid
    Xfeatures = cell(1,2);
    for j=1:2
        fun = @(x) LaplacianPyramid(x,j);
        Xfeatures{j} = nlfilter(I, [9 9], fun);
        Xfeatures{j} = filter2(H,Xfeatures{j},'valid');
        imwrite(mat2gray(Xfeatures{j}),[dir, 'temp.png'])
        rgb = ind2rgb(imread([dir, 'temp.png']),jet(256));
        imwrite(rgb,[dir, name{i}, '_LaplacianPyramid', num2str(j) '.png'])
        disp(['LaplacianPyramid: ', num2str(i), ' ', num2str(j)])
    end
    save([dir, name{i}, '_LaplacianPyramid.mat'],'Xfeatures')
    end
    %~ % SteerablePyramid
    %~ Xfeatures = cell(1,8);
    %~ for j=1:8
        %~ fun = @(x) SteerablePyramid(x,j);
        %~ Xfeatures{j} = nlfilter(I, [9 9], fun);
        %~ Xfeatures{j} = filter2(H,Xfeatures{j},'valid');
        %~ imwrite(mat2gray(Xfeatures{j}),[dir, 'temp.png'])
        %~ rgb = ind2rgb(imread([dir, 'temp.png']),jet(256));
        %~ imwrite(rgb,[dir, name{i}, '_SteerablePyramid', num2str(j) '.png'])
        %~ disp(['SteerablePyramid: ', num2str(i), ' ', num2str(j)])
    %~ end
    %~ save([dir, name{i}, '_SteerablePyramid.mat'],'Xfeatures')
    Xfeatures = GaborFeatures(I);
    for j=1:24
        imwrite(mat2gray(Xfeatures{j}),[dir, 'temp.png'])
        rgb = ind2rgb(imread([dir, 'temp.png']),jet(256));
        imwrite(rgb,[dir, name{i}, '_GaborFeatures', num2str(j) '.png'])
        disp(['GaborFeatures: ', num2str(i), ' ', num2str(j)])
    end
    save([dir, name{i}, '_GaborFeatures.mat'],'Xfeatures')
    Xfeatures = LawsOperators(I);
    for j=1:10
        imwrite(mat2gray(Xfeatures{j}),[dir, 'temp.png'])
        rgb = ind2rgb(imread([dir, 'temp.png']),jet(256));
        imwrite(rgb,[dir, name{i}, '_LawsOperators', num2str(j) '.png'])
        disp(['LawsOperators: ', num2str(i), ' ', num2str(j)])
    end
    save([dir, name{i}, '_LawsOperators.mat'],'Xfeatures')
    Xfeatures = PowerSpectrum(I);
    for j=1:10
        imwrite(mat2gray(Xfeatures{j}),[dir, 'temp.png'])
        rgb = ind2rgb(imread([dir, 'temp.png']),jet(256));
        imwrite(rgb,[dir, name{i}, '_PowerSpectrum', num2str(j) '.png'])
        disp(['PowerSpectrum: ', num2str(i), ' ', num2str(j)])
    end
    save([dir, name{i}, '_PowerSpectrum.mat'],'Xfeatures')
    Xfeatures = WignerDistribution(I);
    for j=1:9
        imwrite(mat2gray(Xfeatures{j}),[dir, 'temp.png'])
        rgb = ind2rgb(imread([dir, 'temp.png']),jet(256));
        imwrite(rgb,[dir, name{i}, '_WignerDistribution', num2str(j) '.png'])
        disp(['WignerDistribution: ', num2str(i), ' ', num2str(j)])
    end
    save([dir, name{i}, '_WignerDistribution.mat'],'Xfeatures')
    Xfeatures = LBP(I);
    imwrite(mat2gray(Xfeatures),[dir, 'temp.png'])
    rgb = ind2rgb(imread([dir, 'temp.png']),jet(256));
    imwrite(rgb,[dir, name{i}, '_LBP', num2str(1) '.png'])
    save([dir, name{i}, '_LBP.mat'],'Xfeatures')
    disp(['LBP: ', num2str(i), ' ', num2str(1)])
end
