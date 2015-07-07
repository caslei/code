
I = imreadDM3(strcat('/ipi/shared/biology/dmbr/thesisData/grid-blur/grid manual/image1.dm3'));
J = imreadDM3(strcat('/ipi/shared/biology/dmbr/thesisData/grid-blur/grid manual/image15.dm3'));

% I = I(513:1512, 513:1512);
% J = J(513:1512, 513:1512);

[optimizer, metric] = imregconfig('Multimodal');

[registered, movement] = imregister(I, J, 'translation', optimizer, metric);
% tform = imregtform(I, J, 'translation', optimizer, metric);

figure;imshow(I, [22000 27000]); colormap(gray); title('I');
figure;imshow(J, [22000 27000]); colormap(gray); title('J');
figure;imshow(registered, [22000 27000]); colormap(gray); title('Registered');