
/*
 * housedorf_superpixel.c
 * usage: [d_max, d_mean] = housedorf_superpixel(B_GT, n_seg, B_A)
 *      B_GT: groundtruth boundary image
 *      n_seg: number of groundtruth segments
 *      B_A: boundary image computed by segmentation algorithm
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
    #define D_MAX_OUT plhs[0]
    #define D_MEAN_OUT plhs[1]
    #define B_GT_IN prhs[0]
    #define N_SEG_IN prhs[1]
    #define B_A_IN prhs[2]

    double *B_A, *B_GT, d_max, d_mean, *d_max_segs, *d_mean_segs, d, curr_d_min;
    int M, N, m, n, i, j, n_seg, *size_segs;
    
    if(nrhs != 3) /* Check the number of arguments */
        mexErrMsgTxt("Wrong number of input arguments.");
    else if(nlhs != 2)
        mexErrMsgTxt("Wrong number of output arguments.");
    if(!IS_REAL_2D_FULL_DOUBLE(B_A_IN)) /* Check B_A */
        mexErrMsgTxt("B_A must be a real 2D full double array.");
    if(!IS_REAL_2D_FULL_DOUBLE(B_GT_IN)) /* Check B_GT */
        mexErrMsgTxt("B_GT must be a real 2D full double array.");
    if(!(mxGetM(B_A_IN) == mxGetM(B_GT_IN) && mxGetN(B_A_IN) == mxGetN(B_A_IN)))
        mexErrMsgTxt("B_A and B_GT must be of the same size.");
    
    M = mxGetM(B_A_IN); /* Get the dimensions */
    N = mxGetN(B_A_IN);
    B_GT = mxGetPr(B_GT_IN); /* Get the pointer to the data of B_GT */
    n_seg = mxGetScalar(N_SEG_IN); /* Get the number of segments */
    B_A = mxGetPr(B_A_IN); /* Get the pointer to the data of B_A */

    
    d_max_segs = malloc((1+n_seg)*sizeof(double));
    d_mean_segs = malloc((1+n_seg)*sizeof(double));
    size_segs = malloc((1+n_seg)*sizeof(int));
    for (i=0; i<n_seg+1; i++) {
        d_max_segs[i] = 0;
        d_mean_segs[i] = 0;
        size_segs[i] = 0;
    }
    
    for(n=0; n<N; n++) {
        for (m=0; m<M; m++) {
            if (B_GT[m+M*n]) { /* Boundary segment pixel */
                size_segs[(int)B_GT[m+M*n]] = size_segs[(int)B_GT[m+M*n]] + 1; /* Increment current segment size */
                curr_d_min = -1.0; 
                for(j=0; j<N; j++) {
                    for(i=0; i<M; i++) {
                        if ((int)B_A[i+M*j]) { /* Boundary superpixel */
                            d = sqrt((n-j)*(n-j)+(m-i)*(m-i)); /* Compute distance between segment and superpixel boundary pixel */ 
                            if (curr_d_min < 0.0 || d < curr_d_min) { /* Save smallest distance for d_max */ 
                                curr_d_min = d;
                            } 
                        }
                    }
                }
                d_mean_segs[(int)B_GT[m+M*n]] = d_mean_segs[(int)B_GT[m+M*n]] + curr_d_min; /* Save cum sum for d_mean */ 
                if (curr_d_min > d_max_segs[(int)B_GT[m+M*n]]) {
                    d_max_segs[(int)B_GT[m+M*n]] = curr_d_min; /* Save d_max */ 
                }
            }
        }
    }
    
    d_max = 0;
    d_mean = 0;
    for(i=1; i<n_seg+1; i++) { /* Pick d_max and d_mean */ 
        d_max = d_max + d_max_segs[i]; 
        d_mean = d_mean + (d_mean_segs[i] / size_segs[i]);
    }
    d_max = d_max/n_seg;
    d_mean = d_mean/n_seg;
    
    D_MAX_OUT = mxCreateDoubleScalar(d_max); 
    D_MEAN_OUT = mxCreateDoubleScalar(d_mean); 
    
    free(d_max_segs);
    free(d_mean_segs);
    free(size_segs);

}