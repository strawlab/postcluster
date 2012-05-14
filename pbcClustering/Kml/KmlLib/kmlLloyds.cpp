//      File:       kmlLloyds.cpp
//      Programmer: Elke Braun, Bielefeld University
//      Description:Function for calculating kmeans following the Lloyds 
//                  iteration.
//                  Implementation is derived from  
//	            File:		kmlsample.cpp
//	            Programmer:	        David Mount
//	            Last modified:	05/14/04
//	            Description:	Sample program for kmeans
//----------------------------------------------------------------------
// Original file is:
// Copyright (C) 2004-2005 David M. Mount and University of Maryland
// All Rights Reserved.
// 
// This program is free software; you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation; either version 2 of the License, or (at
// your option) any later version.  See the file Copyright.txt in the
// main directory.
// 
// The University of Maryland and the authors make no representations
// about the suitability or fitness of this software for any purpose.
// It is provided "as is" without express or implied warranty.
// 
// This file is:
// Copyright (C) 2009 Elke Braun,Bielefeld University
// All Rights Reserved. Puplished under GNU General Public License, 
// see above for details
//----------------------------------------------------------------------

#include <cstdlib>			// C standard includes
#include <iostream>			// C++ I/O
#include <string>			// C++ strings

#include "../kmlocal-1.7.1/src/KMdata.h"	      // k-means algorithms
#include "../kmlocal-1.7.1/src/KMeans.h"	      // k-means algorithms
#include "../kmlocal-1.7.1/src/KMlocal.h"

#include "kmlLloyds.h"			// k-means algorithms

using namespace std;			// make std:: available


//----------------------------------------------------------------------
//  Termination conditions
//	These are explained in the file KMterm.h and KMlocal.h.  Unless
//	you are into fine tuning, don't worry about changing these.
//----------------------------------------------------------------------
KMterm	term(100, 0, 0, 0,		// run for 100 stages
		0.10,			// min consec RDL
		0.001,			// min accum RDL
		10,			// max run stages
		0.50,			// init. prob. of acceptance
		10,			// temp. run length
		0.95);			// temp. reduction factor



//----------------------------------------------------------------------
//  Main working function, wrapper for original kml software 
//  from David Mount
//----------------------------------------------------------------------
void kmlLloyds(double *data[], int nbPnts, int dim, int k, int stages, 
               int idxData[], double **clResults, double *sums)
{
  KMfilterCenters *ctrs = NULL;
  KMlocalLloyds *kmLloyds = NULL;		// repeated Lloyd's
  int p;
  KMctrIdxArray closeCtr = new KMctrIdx[nbPnts];
  double* sqDist = new double[nbPnts];

 
  kmStatLev = SILENT;		                // level of statistics detail
  term.setAbsMaxTotStage(stages);		// set number of stages

  KMdata dataPts(dim, nbPnts);		// allocate data storage
    		
  //  cout << "Cluster " << dim << " dimensions into " << k << 
  //   " clusters on " << nbPnts << " data Points at all\n";// echo data points

  for (p=0; p<nbPnts; p++)
    kmCopyPt(dim, data[p], dataPts[p]);	

  dataPts.buildKcTree();			// build filtering structure

  ctrs = new KMfilterCenters(k, dataPts);		// allocate centers

    					// run each of the algorithms
  //  cout << "\n" << "Executing Clustering Algorithm: Lloyd's\n";
  kmLloyds = new KMlocalLloyds(*ctrs, term);    // repeated Lloyd's
  *ctrs = kmLloyds->execute();	                // execute


  //kmPrintPts("centers", ctrs->getCtrPts(), k, dim);
  if (clResults)
    kmCopyPts(k, dim, ctrs->getCtrPts(), clResults);
  
    					// get/print final cluster assignments
  ctrs->getAssignments(closeCtr, sqDist);

  if (sums)
    for (int i = 0; i < k; i++) 
      sums[i] = 0.0;

  for (int i = 0; i < nbPnts; i++) 
  {
    idxData[i] = closeCtr[i];
    
    if (sums)
      sums [closeCtr[i]]+=sqDist[i]; 
  }

  delete [] closeCtr;
  delete [] sqDist;
  

  delete (kmLloyds);
  kmLloyds = NULL;
  delete(ctrs);
  ctrs = NULL;
}


