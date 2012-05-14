import numpy as np
from cython.operator cimport dereference as deref
cimport numpy as np
cimport cython

cdef extern from "KMeans.h":
    ctypedef double *KMpoint
    ctypedef double *KMcenter
    ctypedef double *KMdataPoint

cdef extern from "KMterm.h":
    cdef cppclass KMterm:
        KMterm(double, double, double, double,
               double, double, int,
               double, int, double)

cdef extern from "KMlocal.h":
    cdef cppclass KMlocalLloyds:
        KMlocalLloyds(KMfilterCenters, KMterm)
        KMfilterCenters execute()
        KMfilterCenters* execute_to_new()

cdef extern from "KMdata.h":
    cdef cppclass KMdata:
        KMdata( int dim, int maxPts )

        KMdataPoint& operator[](int)
        KMdataPoint& get(int)

        void buildKcTree()

# cdef extern from "KMcenters.h":
#     cdef cppclass KMcenters:
#         KMcenters( int, KMdata)
#         int getK()
#         int getDim()
#         KMcenter get(int)

cdef extern from "KMfilterCenters.h":
    #cdef cppclass KMfilterCenters(KMcenters):
    cdef cppclass KMfilterCenters:
        KMfilterCenters( int, KMdata)
        int getK()
        int getDim()
        KMcenter get(int)

cdef class KMLocal:
    cdef KMdata* dataPts
    cdef KMfilterCenters* ctrs
    cdef int k
    cdef int numFeatures

    def __init__(self, np.ndarray[np.float_t, ndim=2] data, int k_):
        cdef int maxPts
        cdef int nPts = 0
        cdef int d
        cdef KMdataPoint p

        maxPts           = data.shape[0]
        self.numFeatures = data.shape[1]

        self.dataPts = new KMdata(self.numFeatures, maxPts) # allocate data storage

        with cython.boundscheck(False):
            for nPts in range( maxPts ):
                #p = self.dataPts[nPts] # XXX this causes trouble with Cython 0.16.
                p = self.dataPts.get(nPts)
                for d in range( self.numFeatures ):
                    p[d] = data[nPts, d]
        self.dataPts.buildKcTree()

        self.k = k_
        self.ctrs = new KMfilterCenters( self.k, deref(self.dataPts))

    def run(self, algorithm='lloyds'):
        cdef KMterm *term = new KMterm(100, 0, 0, 0,    #  run for 100 stages
                                  0.10,			#  min consec RDL
                                  0.10,			#  min accum RDL
                                  3,			#  max run stages
                                  0.50,			#  init. prob. of acceptance
                                  10,			#  temp. run length
                                  0.95)			#  temp. reduction factor
        cdef KMlocalLloyds* kmLloyds
        cdef int i
        cdef int j
        cdef KMcenter c
        cdef np.ndarray[np.float_t, ndim=2] codebook

        if algorithm=='lloyds':
             kmLloyds = new KMlocalLloyds(deref(self.ctrs), deref(term)) # repeated Lloyd's
             self.ctrs = kmLloyds.execute_to_new()
        else:
            raise ValueError('unknown algorithm "%s"'%algorithm)

        assert self.ctrs.getDim() == self.numFeatures
        codebook = np.empty( (self.ctrs.getK(), self.ctrs.getDim()), dtype=np.float)
        with cython.boundscheck(False):
            for i in range( self.ctrs.getK() ):
                c = self.ctrs.get(i)
                for j in range( self.ctrs.getDim() ):
                    codebook[i,j] = c[j]

        return codebook

def kmeans( data, k):
    kml = KMLocal( data, k )
    codebook = kml.run()
    distortion = np.nan # XXX not implemented yet
    return codebook, distortion

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
