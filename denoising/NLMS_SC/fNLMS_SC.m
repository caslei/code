%% Reconstrueert een ruizig beeld a.d.h.v. het NLMS-SC algoritme (Sectie 3.4)
function [sig_accum, weights_accum] = fNLMS_SC(sig, sig_w, h, corr_filter_inv, alpha, sigma_0, W, wnd_size, weighting_function_name)
%% 

%% Extra parameters
show_progress = 0; % Weergave van progress bar: 1 of 0
%% 

%% NLMS-SC implementatie
% Met dank aan: 
% B. Goossens, H.Q. Luong, A. Pizurica, W. Philips, 
% "An improved non-local means algorithm for image denoising," in 
% 2008 International Workshop on Local and Non-Local Approximation in Image Processing (LNLA2008), 
% Lausanne, Switzerland, Aug. 25-29 (invited paper)
Bs = (2*W+1)^2; 

switch weighting_function_name
    case 'DEFAULT' % LECLERC
        weighting_function = @(r) exp(-r.^2/(h*h)); 
    case 'TUKEY'
        weighting_function = @(r) (r<=h) .* (1-r.*r)/(h*h);
    case 'HUBER'
        weighting_function = @(r) 1./max(1,r/h);
    case 'ANDREWS'
        weighting_function = @(r) (r==0) .* 1 + (r~=0 && r<=h) .* sin(pi*r/h)./(r/h);
    case 'CAUCHY'
        weighting_function = @(r) 1/(1+r.*r/(h*h));
    case 'GEMANMCCLURE'
        weighting_function = @(r) 1./((1+r.*r/(h*h))*(1+r.*r/(h*h)));
    case 'LECLERC'
        weighting_function = @(r) exp(-r.^2/(h*h)); 
    case 'FAIR'
        weighting_function = @(r) 1./(1+r/h);
    case 'BISQUARE'
        weighting_function = @(r) (r<h).*(1-(r/h).^2);
    case 'MODIFIED_BISQUARE'
        weighting_function = @(r) (r<h).*(1-(r/h).^2).^8;
    case 'LOGISTIC'
        weighting_function = @(r) (r==0) .* 1 + (r~=0) .* tanh(r/h)/(r/h);
    case 'TALWAR'
        weighting_function = @(r) (r<h).*1;     
    case 'BLUE'
        weighting_function = @(r) (r<h)./(h*h) + (r>=h)./(r.*r);
end;

sig_prewhit = imfilter(sig_w,corr_filter_inv,'symmetric');
sig_prewhit = sig_prewhit./sqrt(alpha.*sig_w+sigma_0);

sig_prewhit = bound_extension(sig_prewhit,W,W,'mirror');
sig = bound_extension(sig, W, W, 'mirror');
[M, N] = size(sig);

sig_accum = zeros(size(sig, 1), size(sig, 2));
weights_accum = zeros(size(sig));
if show_progress
    bar = waitbar(0, 'NLMS-SC filtering ...');
end
for md = -wnd_size:wnd_size,
    for nd = -wnd_size:wnd_size,
        if show_progress
            waitbar(((md+wnd_size)*(2*wnd_size+1)+(nd+wnd_size))/(2*wnd_size+1)^2);
        end
        if md > 0 || (md == 0 && nd > 0)
            ssd = conv2(conv2((sig_prewhit - circshift(sig_prewhit,[md,nd])).^2, ...
                    ones(1, 2*W+1), 'same'), ones(2*W+1, 1), 'same'); 
            weights = weighting_function(sqrt(ssd/Bs));
            
            weights_accum = weights_accum + weights;
            weights_accum = circshift(circshift(weights_accum,[md,nd]) + weights,[-md,-nd]);
            
            sig_accum = sig_accum + weights.*circshift(sig,[md,nd]);
            sig_accum = circshift(circshift(sig_accum,[md,nd]) + weights.*sig,[-md,-nd]);
        elseif md == 0 && nd == 0,
            weight = 0.2*weighting_function(0);
            weights_accum = weights_accum + weight*ones(size(weights_accum));

            sig_accum = sig_accum + weight*sig;
        end;
    end;
end;
if show_progress
    close(bar);
end

% crop results
weights_accum = weights_accum(W+1:end-W, W+1:end-W);
sig_accum = sig_accum(W+1:end-W, W+1:end-W);
%% 

end

