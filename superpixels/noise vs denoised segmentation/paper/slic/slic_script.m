% SLIC superpixels in combination with different noise types.
% The noise is reduced with the NLMS(-(S)(C)) technique.


% NLMS-SC
tic
disp('NLMS-SC ...');
clear all; close all;
cg_slic_nlmssc_poisscorr
toc

% NLMS-S
tic
disp('NLMS-S ...');
clear all; close all;
cg_slic_nlmss_poiss
toc

% NLMS-C
tic
disp('NLMS-C ...');
clear all; close all;
cg_slic_nlmsc_corr
toc

% NLMS
tic
disp('NLMS ...');
clear all; close all;
cg_slic_nlms_gauss
toc