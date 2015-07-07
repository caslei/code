% 
% I = imread('/ipi/shared/biology/dmbr/FIB-SEM/groundtruth/brain_40nm_cropped/Brain_40nm_stack0004.tif');
% I = I(1:300,360:700,:);
% 
% b_reg1 = I(:,:,1) == I(:,:,2);
% b_reg2 = I(:,:,2) == I(:,:,3);
% b_reg = 1 - b_reg1 .* b_reg2;
% 
% I = double(I(:,:,1));
% 
% figure;
% imshow(uint8(I));
% 
% for i=1:size(I,1)
%     for j=1:size(I,2)
%         if b_reg(i,j)
%             n = 0;
%             I(i,j) = 0;
%             if (~b_reg(i-1,j-1))
%                 I(i,j) = I(i,j)+I(i-1,j-1);
%                 n=n+1;
%             end
%             if (~b_reg(i-1,j))
%                 I(i,j) = I(i,j)+I(i-1,j);
%                 n=n+1;
%             end
%             if (~b_reg(i-1,j+1))
%                 I(i,j) = I(i,j)+I(i-1,j+1);
%                 n=n+1;
%             end
%             if (~b_reg(i,j-1))
%                 I(i,j) = I(i,j)+I(i,j-1);
%                 n=n+1;
%             end
%             if (~b_reg(i,j+1))
%                 I(i,j) = I(i,j)+I(i,j+1);
%                 n=n+1;
%             end
%             if (~b_reg(i+1,j-1))
%                 I(i,j) = I(i,j)+I(i+1,j-1);
%                 n=n+1;
%             end
%             if (~b_reg(i+1,j))
%                 I(i,j) = I(i,j)+I(i+1,j);
%                 n=n+1;
%             end
%             if (~b_reg(i+1,j+1))
%                 I(i,j) = I(i,j)+I(i+1,j+1);
%                 n=n+1;
%             end
%             I(i,j) = I(i,j)/n;
%         end
%     end
% end
% 
% figure;
% imshow(uint8(I));


I = imread('noise-GT.png');
