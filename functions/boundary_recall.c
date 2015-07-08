
/*
 * boundary_recall.c
 * usage: b_r = boundary_recall(B_GT, B_A, d)
 *      B_GT: groundtruth boundary image
 *      B_A: boundary image computed by segmentation algorithm
 *      d: search distance for boundaries (default is 2)
 * usage: [b_r, TP, FN] = boundary_recall(B_GT, B_A, d)
 *      B_GT: groundtruth boundary image
 *      B_A: boundary image computed by segmentation algorithm
 *      d: search distance for boundaries (default is 2)
 */

#include <math.h>
#include <stdlib.h>
#include "mex.h"

#define IS_REAL_2D_FULL_DOUBLE(P) (!mxIsComplex(P) && mxGetNumberOfDimensions(P) == 2 && !mxIsSparse(P) && mxIsDouble(P))
#define IS_REAL_SCALAR(P) (IS_REAL_2D_FULL_DOUBLE(P) && mxGetNumberOfElements(P) == 1)
#define MAX(a,b) ((a>b) ? a:b)
#define MIN(a,b) ((a<b) ? a:b)

/* The gateway function */
void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{
    #define B_R_OUT plhs[0]
    #define TP_OUT plhs[1]
    #define FN_OUT plhs[2]
    #define B_GT_IN prhs[0]
    #define B_A_IN prhs[1]
    #define D_IN prhs[2]

    double *B_A, *B_GT, TP=0.0, FN=0.0;
    int M, N, m, n, i, j, d, m_0, n_0, m_1, n_1, TP_found;
    
    if(nrhs < 2 || nrhs > 3) /* Check the number of arguments */
        mexErrMsgTxt("Wrong number of input arguments.");
    else if(nlhs < 1 || nlhs > 3 || nlhs == 2)
        mexErrMsgTxt("Output argument required.");
    if(!IS_REAL_2D_FULL_DOUBLE(B_A_IN)) /* Check B_A */
        mexErrMsgTxt("B_A must be a real 2D full double array.");
    if(!IS_REAL_2D_FULL_DOUBLE(B_GT_IN)) /* Check B_GT */
        mexErrMsgTxt("B_GT must be a real 2D full double array.");
    if(!(mxGetM(B_A_IN) == mxGetM(B_GT_IN) && mxGetN(B_A_IN) == mxGetN(B_A_IN)))
        mexErrMsgTxt("B_A and B_GT must be of the same size.");
    if(nrhs == 2) /* If d is unspecified, set it to a default value */
        d = 2;
    else /* If d was specified, check that it is a real double scalar */
        if(!IS_REAL_SCALAR(D_IN))
            mexErrMsgTxt("d must be a real integer.");
        else
            d = (int) floor(mxGetScalar(D_IN)); /* Get d */
    
    M = mxGetM(B_A_IN); /* Get the dimensions */
    N = mxGetN(B_A_IN);
    B_GT = mxGetPr(B_GT_IN); /* Get the pointer to the data of B_GT */
    B_A = mxGetPr(B_A_IN); /* Get the pointer to the data of B_A */

    for(n=0; n<N; n++) {
        for (m=0; m<M; m++) {
            /* Define search area */
            m_0 = MAX(MIN(m-d,M-1),0);
            n_0 = MAX(MIN(n-d,N-1),0);
            m_1 = MAX(MIN(m+d,M-1),0);
            n_1 = MAX(MIN(n+d,N-1),0);
            
            if(B_GT[m+M*n]) { /* Boundary pixel in B_GT: check B_A for TP */
                TP_found = 0;
                for(j=n_0; j<n_1+1 && !TP_found; j++) {
                    for(i=m_0; i<m_1+1 && !TP_found; i++) {
                        if(B_A[i+M*j]) {
                            TP++;
                            TP_found = 1;
                        }
                    }
                }
                if(!TP_found) 
                    FN++;
            }
        }
    }
    
    double b_r;
    if(TP==0 && FN==0)
        b_r = -1;
    else
        b_r = TP/(TP+FN);
    
    B_R_OUT = mxCreateDoubleScalar(b_r); 
    if(nlhs == 3) {
        TP_OUT = mxCreateDoubleScalar(TP);
        FN_OUT = mxCreateDoubleScalar(FN);
    }

}