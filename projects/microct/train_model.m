% allows the user to draw n_l_lines, n_h_lines and n_v_lines of three
% different classes. 
% the corresponding set of selected points is returned
function selections = train_model(img, n_classes, n_lines, class_names)

selections = zeros(size(img,1),size(img,2),n_classes);

% show image to annotate
figure,imshow(img,[]);

for i=1:n_classes
    disp(['Please annotate class ' class_names{i}]);
    
    coos = [];
    color = [rand(1),rand(1),rand(1)];
    for j=1:n_lines
        h = imfreehand(gca,'Closed',0);
        setColor(h,color);
        coos = [coos; round(getPosition(h))];
    end
    
    for j=1:size(coos,1)
        selections(coos(j,2),coos(j,1),i) = 1;
    end
end

selections = logical(selections);

end

