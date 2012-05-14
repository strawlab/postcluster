/*
 *  C++ interface routine for calling fast local kmeans algorithm from matlab
 *  CALL:
 *  [idx (centroids) (sums)] = pbc_kmLocal (data nbClusters (nbSteps))
 *
 *  Fast local kmeans implemented by David Mount, published in
 *  Kanungo, Mount, Netanyahu, Piatko, Silverman, et.al.,
 *  'An efficiant k-means clustering algorithm: Analysis ans implementation.'
 *  IEEE Trans. Pattern Analysis and Machine Intelligence, 24:881-892.
 *
 *  Interface to matlab written by 
 *  Bart Geurten, Elke Braun, Bielefeld University, 2009
 *  See: 'Identifying Prototypical Components in Behaviour using 
 *  Clustering Algorithms' for a description of the approach implemented
 *  within this matlab package.      
 *
 *  pbc_kmLocal.mexglx currently compiled for Linux using 
 *  gcc Debian version 4.3.2-1.1.
 *  For compiling on other systems call in matlab:
 *  mex pbc_kmLocal.cpp KmlLib/libkml.a

 ************************************************************************
 * Copyright (C) 2009,  Bart Geurten, Elke Braun, Bielefeld University

 * This program is free software; you can redistribute it and/or modify 
 * it under the terms of the GNU General Public License as published 
 * by the Free Software Foundation; either version 2 of the License, 
 * or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful, 
 * but WITHOUT ANY WARRANTY; without even the implied warranty of 
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. 
 * See the GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License 
 * along with this program; if not, write to the Free Software Foundation,
 * Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
*/

#include <iostream>
#include <cmath>
#include "mex.h"

#include "KmlLib/kmlLloyds.h"

using namespace std;

extern void _main();

/* Working function for doiung the kmeans using the function kmlLloyds()
 * from David Mount's package.
 */
static void doKmLocal(double *dataPnts, int nbDataPnts, int dim, int k, 
		      int nbSteps,
                      int *idxData, double *clResults, double *sums)
{
  int p, d;
  double **dataCSorted = NULL;
  double **resCSorted = NULL;

  /* Prepare the data structures for the call of kmlLloyds(). */ 
  dataCSorted = new double*[nbDataPnts];
  for (p=0;p<nbDataPnts;p++)
      dataCSorted[p] = new double[dim];

  if(clResults)
  {
    resCSorted = new double*[k];
    for (p=0;p<k;p++)
      resCSorted[p] = new double[dim];
  }
  
  for (p=0; p<nbDataPnts; p++)
  {
    for (d=0; d<dim;d++)
      dataCSorted[p][d] = dataPnts[d*nbDataPnts+p];  
  }
    
  
  /* Call the package function that does the clustering */
  kmlLloyds (dataCSorted, nbDataPnts, dim, k, nbSteps, idxData, resCSorted, 
	     sums);


  /* Correct index data for matlab indices ranging from 1 to N 
   * instead of 0 to N-1 */
  for (p=0; p<nbDataPnts; p++)
    idxData[p] += 1;

  /* Copy centroids to appropriate output parameter array and delete
   * intermediate variables */
  if(resCSorted)
  {
    for (p=0;p<k;p++)
      for (d=0;d<dim;d++)
	clResults[d*k+p]= resCSorted[p][d];

    for (p=0;p<k;p++)
      delete(resCSorted[p]);
    delete (resCSorted);
  }
  
  for (p=0;p<nbDataPnts;p++)
    delete(dataCSorted[p]);
  delete(dataCSorted);

  return;
}


/* Standard interface funtion to matlab, see doc mex for details.
 * This function reformats standardized input and output parameters
 * to the data structures needed by doKmLocal(), calls it and returns the
 * results */
void mexFunction(int nlhs, mxArray *plhs[],
		         int nrhs, const mxArray *prhs[])
{
  double      *dataPnts;
  int         nbPnts;
  int         dim;
  int         nbClusters;
  int         nbSteps;
  const int defNbSteps = 1000;

  mwSize      m,n, d;
  
  int         *idxData;
  double      *centroids;
  double      *sumData;
  
  /* Check for proper input arguments */
  if (nrhs < 2 || nrhs > 3) {
    mexErrMsgTxt("Requiring two or three input arguments: data nbClusters (nbSteps)");
  } else if (nlhs < 1 || nlhs > 3) {
    mexErrMsgTxt("Requiring one to three output arguments: [idx (centroids) (sums)] = ....");
  }

  if (mxGetNumberOfDimensions(prhs[0]) != 2)
    mexErrMsgTxt("Expecting 2dim input data.");
  
  m = mxGetM(prhs[0]); 
  n = mxGetN(prhs[0]);
  
  if (m < n)
  {
    mexPrintf("Got %d datapoints with %d dims\n", m, n);
    mexErrMsgTxt("Expecting more data points than dimensions.\n");
  }

  /* Extract data from input arguments */
  dataPnts = (double *) mxGetPr(prhs[0]);

  nbPnts = (int)m;
  dim = (int)n;
  
  if (mxIsNumeric(prhs[1]))
      nbClusters = (int)mxGetScalar(prhs[1]);
  else
     mexErrMsgTxt("Requiring int scalar as second input argument: nbClusters.");
     
  if (nrhs == 3)
  {
    if (mxIsNumeric(prhs[2]))
     nbSteps = (int)mxGetScalar(prhs[2]);
    else
      mexErrMsgTxt("Requiring int scalar as third input argument: nbSteps.");
  }
  else
    nbSteps = defNbSteps;

  /* Create a matrix for the first return argument, the assignment data */ 
  plhs[0] = mxCreateNumericMatrix(m, 1, mxINT32_CLASS, mxREAL); 
  /* Assign pointers to the various parameters */ 
  idxData = (int*)mxGetData(plhs[0]);
  
  /* Create a matrix for the optional seconds return argument, the 
     centroid data, if necessary */ 
  if (nlhs > 1)
  {
    plhs[1] = mxCreateDoubleMatrix(nbClusters, dim, mxREAL); 
    centroids = mxGetPr(plhs[1]);
  }
  else
    centroids = NULL;
      
  /* Create a matrix for the optional third return argument, the 
     error sums data, if necessary */ 
  if (nlhs > 2)
  {
    plhs[2] = mxCreateDoubleMatrix(nbClusters, 1, mxREAL); 
    sumData = mxGetPr(plhs[2]);
  }
  else
    sumData = NULL;
     
  
  /* Call the working routine with the current parameters */
  doKmLocal(dataPnts, nbPnts, dim, nbClusters, nbSteps,
                      idxData, centroids, sumData);
 
  return;
}
