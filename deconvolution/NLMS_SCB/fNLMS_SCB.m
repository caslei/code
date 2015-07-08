
function x_est = fNLMS_SCB(...
                    y, H, lambda, ... % image model / regularization parameters
                    h, corr_filter_inv, alpha, sigma_0, W, wnd_size, weighting_function_name, ... % NLMS_SC parameters
                    x_0, num_iter) % steepest descent parameters

x_est = x_0;
% es = zeros(num_iter,1);
for iter=1:num_iter
    iter
    grad = grad_E(x_est, y, H, lambda, h, corr_filter_inv, alpha, sigma_0, W, wnd_size, weighting_function_name);
    H_grad = imfilter(grad,H,'symmetric');
    [NLMS_grad_cum, NLMS_weights_cum] = fNLMS_SC(grad, y, h, corr_filter_inv, alpha, sigma_0, W, wnd_size, weighting_function_name);
    temp = NLMS_weights_cum.*grad - NLMS_grad_cum;
    alpha_step = (2*lambda*inprod(x_est, temp) - inprod(y-imfilter(x_est,H,'symmetric'),H_grad)) / ... 
            (2*lambda*inprod(grad, temp) + (norm_2(H_grad)));
    x_est = x_est - alpha_step*grad;
    % es(iter) = log(norm_2(grad));
end
% figure; plot(es);

end

function energy = E(x, y, H, lambda, h, corr_filter_inv, alpha, sigma_0, W, wnd_size, weighting_function_name)
    [NLMS_x_cum, NLMS_weights_cum] = fNLMS_SC(x, y, h, corr_filter_inv, alpha, sigma_0, W, wnd_size, weighting_function_name);
    energy = norm_2(y-imfilter(x,H,'symmetric')) + 2*lambda*inprod(x, NLMS_weights_cum.*x - NLMS_x_cum);
end

function grad = grad_E(x, y, H, lambda, h, corr_filter_inv, alpha, sigma_0, W, wnd_size, weighting_function_name)
    H_T = H;
    [NLMS_x_cum, NLMS_weights_cum] = fNLMS_SC(x, y, h, corr_filter_inv, alpha, sigma_0, W, wnd_size, weighting_function_name);
    grad = 2*(imfilter(imfilter(x,H,'symmetric'),H_T,'symmetric') - imfilter(y,H_T,'symmetric') + ...
              2*lambda*(NLMS_weights_cum.*x - NLMS_x_cum));
end

function e = norm_2(x)
    e = inprod(x,x);
end

function e = inprod(x, y)
    e = sum(sum(x.*y));
end