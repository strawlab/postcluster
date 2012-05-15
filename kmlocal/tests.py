from pykmlocal import kmeans
import numpy as np

def test_kmeans():
    data = np.array([[0, 0],
                     [0, 1],
                     [1, 1],
                     [-1, 1],

                     [10,10],
                     [11,10],
                     [10,11],
                     [10,10.1],

                     [-100, -100],
                     [-101, -100],
                     [-102, -100],
                     ],
                    dtype=np.float)
    codebook, dist = kmeans( data, 3)
    print 'codebook'
    print codebook

def test_kmeans_random():
    data = np.random.randn( 1000, 3 )
    data[500:] += np.array([ 10,10,10])
    codebook1, dist = kmeans( data, 2)
    print codebook1

    codebook2, dist = kmeans( data, 2)
    print codebook2

    codebook3, dist = kmeans( data, 2)
    print codebook3


