#include "mex.h"

void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[]){

	// Input Array

	if (nrhs != 3)		mexErrMsgTxt("Three inputs required.");

	double*		X = mxGetPr(prhs[0]);
	int			X_m = mxGetM(prhs[0]);
	int			X_n = mxGetN(prhs[0]);

	double*		J = mxGetPr(prhs[1]);
	int			J_m	= mxGetM(prhs[1]);
	int			J_n = mxGetN(prhs[1]);
    
    double      numData_effective = mxGetScalar(prhs[2]);
    int         n = int(numData_effective);
	
	// Output Array

	plhs[0] = mxCreateDoubleMatrix(n, 1, mxREAL);

	double*		Y = mxGetPr(plhs[0]);

    int     jj, kk;
    int     m = X_m * X_n;
    
    double*   C = (double*)mxMalloc(n * sizeof(double));
    
    for(jj = 0; jj < n; jj++) {
      
        Y[jj] = 0.0;
        C[jj] = 0.0;
    }
    
    for(kk = 0; kk < m; kk++) {
        
        jj = int(J[kk]) - 1;
        
        Y[jj] += X[kk];
        C[jj] += 1.0;
    }
    
    for(jj = 0; jj < n; jj++){
        
        Y[jj] /= C[jj];
    }
    
    mxFree(C);
}

// Copyright 2017 The MathWorks, Inc.
