#!/usr/bin/env python
"""save a dataset that can be tested in MATLAB and in Python
"""
import random
import numpy as np
import scipy.io
from scipy.cluster.vq import vq

import sys, os

if 1:
    # even if postcluster is not installed, put it in path
    mydir = os.path.split( os.path.abspath(__file__))[0]
    postcluster_dir = os.path.abspath(os.path.join(mydir,'..'))
    sys.path.insert(0, postcluster_dir )

import postcluster

d1 = np.random.randn( 10 )+3
d2 = np.random.randn( 10 )+3

d3 = np.random.randn( 10 )-3
d4 = np.random.randn( 10 )-3

z = np.random.randn( 10 )*0.1

d = []
for a, b, zi  in zip( d1, d2, z):
    d.append( (a, b, zi) )
for a, b, zi in zip( d3, d4, z):
    d.append( (a, b, zi) )
random.shuffle(d)
d = np.array(d)

codebook0 = np.array( [[3,3,0],
                       [-3,-3,0]], dtype = np.float )

codebook1 = np.array( [[3.1,3,0],
                       [-3,-3,0]], dtype = np.float )

codebook2 = np.array( [[3.1,4.0,0],
                       [-3,-3,0]], dtype = np.float )

codebook3 = np.array( [[3.1,5.0,0],
                       [-3,-3,0]], dtype = np.float )

IDX0,_ = vq( d, codebook0 )
IDX1 = IDX0+1 # one-based indexing
SUMD,_ = postcluster.get_summed_inner_distance( codebook0, d )

scipy.io.savemat('generated_data',
                 {'X':d,
                  'codebook0':codebook0,
                  'codebook1':codebook1,
                  'codebook2':codebook2,
                  'codebook3':codebook3,
                  'IDX0':IDX0,
                  'IDX1':IDX1,
                  'SUMD':SUMD,
                  }, oned_as='column')
