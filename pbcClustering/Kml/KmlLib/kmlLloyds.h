//      File:       kmlLloyds.h
//      Programmer: Elke Braun, Bielefeld University
//      Description:Declaration of function for calculating kmeans 
//                  following the Lloyds iteration.
//
// Copyright (C) 2009,  Bart Geurten, Elke Braun, Bielefeld University
//
// This program is free software; you can redistribute it and/or modify 
// it under the terms of the GNU General Public License as published 
// by the Free Software Foundation; either version 2 of the License, 
// or (at your option) any later version.
//
// This program is distributed in the hope that it will be useful, 
// but WITHOUT ANY WARRANTY; without even the implied warranty of 
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. 
// See the GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License 
// along with this program; if not, write to the Free Software Foundation,
// Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA

#ifndef _KMLLLOYSD_H_
#define _KMLLLOYSD_H_

void kmlLloyds(double *data[], int nbPnts, int dim, int k, int stages, 
	      int idxData[], double **clResults, double *sums);

#endif
