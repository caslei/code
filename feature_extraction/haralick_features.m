function features = haralick_features(img,num_levels,offsets)

if nargin<2
    num_levels = 8;
end
if nargin<3
    offsets = [-1 1; -1 0; -1 -1; 0 1; 0 -1; 1 1; 1 0; 1 -1];
end

glcms = graycomatrix(img,'NumLevels',num_levels,'Offset',offsets);
glcm = sum(glcms,3)/size(glcms,3);
features_struct = GLCM_Features1(glcm,0);
features = zeros(22,1);
features(1) = features_struct.autoc;
features(2) = features_struct.contr;
features(3) = features_struct.corrm;
features(4) = features_struct.corrp;
features(5) = features_struct.cprom;
features(6) = features_struct.cshad;
features(7) = features_struct.dissi;
features(8) = features_struct.energ;
features(9) = features_struct.entro;
features(10) = features_struct.homom;
features(11) = features_struct.homop;
features(12) = features_struct.maxpr;
features(13) = features_struct.sosvh;
features(14) = features_struct.savgh;
features(15) = features_struct.svarh;
features(16) = features_struct.senth;
features(17) = features_struct.dvarh;
features(18) = features_struct.denth;
features(19) = features_struct.inf1h;
features(20) = features_struct.inf2h;
features(21) = features_struct.indnc;
features(22) = features_struct.idmnc;

end

