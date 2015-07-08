
/*
 * under_segmentation_error.c
 * usage: u_e = under_segmentation_error(B_GT, n_GT, B_A, n_A)
 *      B_GT: groundtruth segmented (labeled) image
 *		n_GT: number of segments in groundtruth (labels are assumed 1, 2, ..., n_GT)
 *      B_A: segmented (labeled) image computed by segmentation algorithm
 *		n_GT: number of segments in computed image (labels are assumed 1, 2, ..., n_A)
 */

#include <math.h>
#include <stdlib.h>
#include "mex.h"

#define IS_DOUBLE(P) (!mxIsComplex(P) && mxIsDouble(P))
#define IS_REAL_2D_FULL_DOUBLE(P) (IS_DOUBLE(P) && mxGetNumberOfDimensions(P) == 2 && !mxIsSparse(P))
#define IS_REAL_SCALAR(P) (IS_REAL_2D_FULL_DOUBLE(P) && mxGetNumberOfElements(P) == 1)
#define MAX(a,b) ((a>b) ? a:b)
#define MIN(a,b) ((a<b) ? a:b)

/* The gateway function */
void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{
    #define UE_OUT plhs[0]
    #define B_GT_IN prhs[0]
    #define N_GT_IN prhs[1]
    #define B_A_IN prhs[2]
    #define N_A_IN prhs[3]

    double *B_A, *B_GT, b_rel, u_e;
    int M, N, i, j, n, m, s_j_is_g_i, s_j, n_GT, n_A;
    
    if(nrhs != 4) /* Check the number of arguments */
        mexErrMsgTxt("Wrong number of input arguments.");
    else if(nlhs < 1)
        mexErrMsgTxt("Output argument required.");
    if(!IS_REAL_2D_FULL_DOUBLE(B_A_IN)) /* Check B_A */
        mexErrMsgTxt("B_A must be a real 2D full double array.");
    if(!IS_DOUBLE(N_A_IN)) /* Check n_A */
        mexErrMsgTxt("n_A must be a real double.");
    if(!IS_REAL_2D_FULL_DOUBLE(B_GT_IN)) /* Check B_GT */
        mexErrMsgTxt("B_GT must be a real 2D full double array.");
    if(!IS_DOUBLE(N_GT_IN)) /* Check n_GT */
        mexErrMsgTxt("n_GT must be a real double.");
    if(!(mxGetM(B_A_IN) == mxGetM(B_GT_IN) && mxGetN(B_A_IN) == mxGetN(B_A_IN)))
        mexErrMsgTxt("B_A and B_GT must be of the same size.");
    
    M = mxGetM(B_A_IN); /* Get the dimensions */
    N = mxGetN(B_A_IN);
    B_GT = mxGetPr(B_GT_IN); /* Get the pointer to the data of B_GT */
	n_GT = (double) mxGetScalar(N_GT_IN); /* Get n_GT */
    B_A = mxGetPr(B_A_IN); /* Get the pointer to the data of B_A */
	n_A = (double) mxGetScalar(N_A_IN); /* Get n_A */

    u_e = 0;
    for(i=1; i<n_GT; i++) {
        for (j=1; j<n_A; j++) {
            s_j = 0; /* j'th segment size in B_A */
            s_j_is_g_i = 0; /* intersection of the i'th groundtruth segment and the j'th computed segment */
            for (n=0; n<N; n++) {
                for (m=0; m<M; m++) {
                    if (B_A[m+M*n] == j) { /* j'th segment in B_A */
                        s_j++;
                        if (B_GT[m+M*n] == i) { /* i'th segment size in B_GT */
                            s_j_is_g_i++;
                        }
                    }
                }
            }
            if (s_j_is_g_i)
                u_e += (1-(s_j_is_g_i/s_j));
        }
    }
    u_e = u_e / (n_GT*n_A);
    
    UE_OUT = mxCreateDoubleScalar(u_e); 

}
