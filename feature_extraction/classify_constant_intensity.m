function [patches,values] = classify_constant_intensity(features)

T_corrm = 0.1;
T_cprom = 0.3;
T_cshad = 0.05;
T_dissi = 0.1;
T_entro = 0.6;
T_homom = 0.95;
T_senth = 0.5;
T_denth = 0.35;
T_dvarh = 0.15;

T_total = 0.0;

values = zeros(1,numel(features));
index = 1;
for i=1:numel(features)
    v = 0;
    f = features{i};
    v = v + max(0,f.corrm-T_corrm);
    v = v + max(0,f.cprom-T_cprom);
    v = v + max(0,abs(f.cshad)-T_cshad);
    v = v + max(0,f.dissi-T_dissi);
    v = v + max(0,f.entro-T_entro);
    v = v + abs(min(0,f.homom-T_homom));
    v = v + max(0,f.senth-T_senth);
    v = v + max(0,f.denth-T_denth);
    v = v + max(0,f.dvarh-T_dvarh);
    values(i) = v;
    if v<=T_total
        patches{index} = [f.row, f.col];
        index = index+1;
    end
end

end

