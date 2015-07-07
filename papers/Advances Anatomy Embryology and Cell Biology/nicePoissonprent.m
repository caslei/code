x = double(imread('OpnameEMHR.jpg'));

n = randn(size(x));
a=0.5;


for i=1:size(x,2)
    yg(:,i)=x(:,i)+sqrt((a*i).*mean(x(:,i))).*n(:,i); %128 is the average gray value
end;
yg(yg<0)=0;
yg(yg>255)=255;
%imagesc(yg);colormap(gray);

for i=1:size(x,2)
    yp(:,i)=x(:,i)/(a*i);
end;
yp=poissrnd(yp);
for i=1:size(x,2)
    yp(:,i)=yp(:,i)*(a*i);
end;
yp(yp<0)=0;
yp(yp>255)=255;
%figure;imagesc([yg(1:end/2,:);yp(end/2+1:end,:)]);colormap(gray);
output= [yg(1:end/2,:);yp(end/2+1:end,:)];

for i=1:size(x,1)
    num_bits=9-(floor(((i-1)/2)/size(x,1)*8)+1)
    yq(i,:)=x(i,:);
    yq(i,yq(i,:)<128-2^(num_bits-1))=128-2^(num_bits-1);
    yq(i,yq(i,:)>128+2^(num_bits-1))=128+2^(num_bits-1);
    yq(i,:)=(yq(i,:)-128)*256/(2^(num_bits))+128;
end;
for i=1:size(x,2)
    num_bits=9-(floor((i-1)/size(x,2)*8)+1);
    num_intensities=2^num_bits;
    yq(:,i)=floor(yq(:,i)/255*(num_intensities-1))/(num_intensities-1)*255;
end;
figure;imagesc(yq);colormap(gray);


% for i=1:size(x,1)
%     num_bits=9-(floor(((i-1)/2)/size(x,1)*8)+1)
%     yq(i,:)=x(i,:);
%     yq(i,yq(i,:)<128-2^(num_bits-1))=128-2^(num_bits-1);
%     yq(i,yq(i,:)>128+2^(num_bits-1))=128+2^(num_bits-1);
%     yq(i,:)=(yq(i,:)-128)*256/(2^(num_bits))+128;
%     
%     bitmap(i,1:size(x,2))=num_bits;
% end;
% for i=1:size(x,2)
%     num_bits=9-(((i-1))/size(x,2)*8+1);
%     num_bits=num_bits+(8-bitmap);
%     num_bits(num_bits<1)=1;
%     num_intensities=2.^num_bits;
%     yq(:,i)=floor(yq(:,i)./255.*(num_intensities(:,i)-1))./(num_intensities(:,i)-1)*255;
% end;
% figure;imagesc(yq);colormap(gray);