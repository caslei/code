
for i=1:650
    load(['/net/ipi/scratch/jbroels/microct/segmentation results/F_3D_' num2str(i) '.mat']);
    edges = labels2edges(F_3D_i);
    cc = bwconncomp(edges);
    n = cc.NumObjects;
    dir = ['/net/ipi/scratch/jbroels/microct/edges processed to txt/slice_' num2str(i)];
    mkdir(dir);
    for j=1:n
        pxls = cc.PixelIdxList(j);
        pxls = pxls{1};
        [x_c,y_c] = co1D_to_co2D(pxls,[1300,1684]);
        fileID = fopen([dir '/comp_' num2str(j) '.txt'],'w');
        for k=1:numel(pxls)
            fprintf(fileID,'%d,%d\n',x_c(k),y_c(k));
        end
        fclose(fileID);
    end
end