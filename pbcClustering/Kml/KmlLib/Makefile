#-----------------------------------------------------------------------------
# Makefile for the kmLocal library
#
# Programmer: Elke Braun, Bielefeld University, derived from a Makefile
#             written by David M. Mount, University of Maryland
# Description:Makefile for generating library for calculating kmeans 
#             following the Lloyds iteration.
#             Used source code is partly written by the author and
#             partly written by David M. Mount, University of Maryland,
#             published under GPL  
#-----------------------------------------------------------------------------
#      Programmer: Elke Braun, Bielefeld University
#      Description:Declaration of function for calculating kmeans 
#                  following the Lloyds iteration.
#
# Copyright (C) 2009,  Bart Geurten, Elke Braun, Bielefeld University
#
# This program is free software; you can redistribute it and/or modify 
# it under the terms of the GNU General Public License as published 
# by the Free Software Foundation; either version 2 of the License, 
# or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful, 
# but WITHOUT ANY WARRANTY; without even the implied warranty of 
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. 
# See the GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License 
# along with this program; if not, write to the Free Software Foundation,
# Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA


#-----------------------------------------------------------------------------
# Basic definitions
#		SRC_DIR		where to find the original kml sources
#-----------------------------------------------------------------------------

SRC_DIR		= kmlocal-1.7.1/src
OTHERLIBS	= -lm

#-----------------------------------------------------------------------------
# Some more definitions
#-----------------------------------------------------------------------------


TESTOBJECTS = $(SRC_DIR)/KM_ANN.o $(SRC_DIR)/KMeans.o \
	$(SRC_DIR)/KMterm.o $(SRC_DIR)/KMrand.o \
	$(SRC_DIR)/KCutil.o $(SRC_DIR)/KCtree.o $(SRC_DIR)/KMdata.o \
	$(SRC_DIR)/KMcenters.o \
	$(SRC_DIR)/KMfilterCenters.o $(SRC_DIR)/KMlocal.o

LIBOBJECTS = $(TESTOBJECTS) kmlLloyds.o

KMLLIB = libkml.a

#-----------------------------------------------------------------------------
# Compiler and compilation options:
#
#	C++		your C++ compiler
#	CFLAGS (for g++)
#		-O[1-3]        	Optimization
#		-g          	Debugging
#                               (may slow execution slightly)
#		-DASSERT	Enable assertion checking
#                               (may slow execution slightly)
#-----------------------------------------------------------------------------
C++ = g++
CFLAGS = -I $(SRC_DIR) -O3 -Wall -DASSERT

AR = ar
ARFLAGS =  -rs

#-----------------------------------------------------------------------------
# Make the library
#-----------------------------------------------------------------------------

$(KMLLIB): $(LIBOBJECTS)
	$(AR) $(ARFLAGS) $(KMLLIB) $(LIBOBJECTS)

#-----------------------------------------------------------------------------
# Object files
#-----------------------------------------------------------------------------

kmlLloyds.o: kmlLloyds.h kmlLloyds.cpp
	$(C++) -c $(CFLAGS) -o $@ kmlLloyds.cpp

#-----------------------------------------------------------------------------
# Cleaning
#-----------------------------------------------------------------------------

clean:
	-rm -f *.a *.o *.obj *.fig *.bak *.dmp *.cpp~ *.h~

