function f = estimate_variance(patches)

num_patches = size(patches,3);

vars = zeros(num_patches,1);
intensities = zeros(num_patches,1);

for i=1:num_patches
    intensity = mean2(patches(:,:,i));
    [mu, sigma] = normfit(reshape(patches(:,:,i), size(patches,1)*size(patches,2), 1));
    intensities(i, 1) = intensity;
    vars(i, 1) = sigma^2;
end

figure('Name','Signal Dependency','NumberTitle','off');
f = fit(intensities, vars, 'poly1');
plot(f, intensities, vars);
legend('Data','Fitted curve');
title('Signal dependency');
title(strcat('Equation fitted curve: y = ',num2str(f.p1),'*x+',num2str(f.p2)));
xlabel('Signal intensity');
ylabel('Noise variance');

end

