function img = read_img(i)
    im_dir = '/ipi/shared/biology/dmbr/SBF-SEM/cross_sample/';
    if i<10
        num = strcat('00',num2str(i));
    else if i<100
            num = strcat('0',num2str(i));
        else 
            num = num2str(i);
        end
    end
    img = double(dmread(strcat(im_dir,num,'.dm3')));
end