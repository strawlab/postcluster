import numpy as np
import scipy.io
from scipy.cluster.vq import vq, kmeans, whiten
import sys, os

if 1:
    # even if postcluster is not installed, put it in path
    mydir = os.path.split( os.path.abspath(__file__))[0]
    postcluster_dir = os.path.abspath(os.path.join(mydir,'..'))
    sys.path.insert(0, postcluster_dir )

import postcluster

mdata = scipy.io.loadmat('generated_data.mat',struct_as_record=True)
X = mdata['X']
codebook0 = mdata['codebook0']
codebook1 = mdata['codebook1']
codebook2 = mdata['codebook2']
codebook3 = mdata['codebook3']

all_codebooks = np.array( [codebook0, codebook1, codebook2, codebook3] )
instability_results = postcluster.match_centroids( all_codebooks )
instability = instability_results['mean_instability']

quality = postcluster.get_quality( codebook0, X )

print "instability: %.5f"%instability
print "quality: [%.5f, %.5f]"%(quality[0], quality[1])
print
