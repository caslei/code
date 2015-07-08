
function x_est = fTV(y, H, lambda, ... % image model / regularization parameters
                     x_0, num_iter) % steepest descent parameters

x_est = x_0;
% es = zeros(num_iter,1);
for iter=1:num_iter
    % iter
    grad = grad_E(x_est, y, H, lambda);
    % alpha_step = (2*lambda*inprod(x_est, temp) - inprod(y-imfilter(x_est,H,'symmetric'),H_grad)) / ... 
    %         (2*lambda*inprod(grad, temp) + (norm_2(H_grad)));
    alpha_step = 0.05;
    x_est = x_est - alpha_step*grad;
    % es(iter) = norm_2(grad);
end
% figure; plot(es);

end

function tv = total_variation(x)
    h_f = [-1,1,0];
    v_f = h_f';
    tv = sum(sum(sqrt(imfilter(x,h_f).^2 + imfilter(x,v_f).^2)));
end

function energy = E(x, y, H, lambda)
    energy = norm_2(y-imfilter(x,H,'symmetric')) + lambda*total_variation(x);
end

function grad = grad_E(x, y, H, lambda)
    f1 = [0,-1,0;-1,2,0;0,0,0];
    f2 = [0,-1,1];
    f3 = f2';
    tv1 = total_variation(x);
    x_temp = circshift(x,[0,-1]);
    x_temp(:,end) = x_temp(:,end-2);
    tv2 = total_variation(x_temp);
    x_temp = circshift(x,[-1,0]);
    x_temp(:,end) = x_temp(:,end-2);
    tv3 = total_variation(x_temp);
    d = 10^(-8);
    H_T = H;
    grad = 2*(imfilter(imfilter(x,H,'symmetric'),H_T,'symmetric') - imfilter(y,H_T,'symmetric')) + ...
           lambda*(imfilter(x,f1,'symmetric')/(tv1+d) + imfilter(x,f2,'symmetric')/(tv2+d) + imfilter(x,f3,'symmetric')/(tv3+d));
end

function e = norm_2(x)
    e = inprod(x,x);
end

function e = inprod(x, y)
    e = sum(sum(x.*y));
end