import scipy.io
import numpy as np
import postcluster
from scipy.cluster.vq import vq

def test_sumd():
    data = scipy.io.loadmat('test_sumd.mat',struct_as_record=True)['X']
    codebook = np.array([[3.6211,   3.1914],
                         [-3.6694, -3.3425]])

    actual_code, dist = vq( data, codebook)
    actual_dist, count = postcluster.get_summed_inner_distance( codebook, data )

    # The hard-coded expected values -- pre-computed using MATLAB kmeans().
    expected_code = np.array([1, 0, 0, 0, 1, 1, 1, 0, 0, 1, 1, 1, 1, 0, 0, 0, 0, 1, 0, 1])
    expected_dist = np.array([21.9997,18.1554])

    assert np.allclose( actual_code, expected_code )

    assert np.allclose( actual_dist, expected_dist )
