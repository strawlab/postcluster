import os, sys, subprocess
from distutils.core import setup, Extension
from Cython.Distutils import build_ext

setup(name='pykmlocal',
      version='1.7.2',
      cmdclass={'build_ext': build_ext},
      ext_modules=[Extension(name="pykmlocal",
                             sources=['src/pykmlocal.pyx',
                                      'src/KCtree.cpp',
                                      'src/KCutil.cpp',
                                      'src/KM_ANN.cpp',
                                      'src/KMcenters.cpp',
                                      'src/KMdata.cpp',
                                      'src/KMeans.cpp',
                                      'src/KMfilterCenters.cpp',
                                      'src/KMlocal.cpp',
                                      'src/KMrand.cpp',
                                      'src/KMterm.cpp',
                                      ],
                             language="c++", # Cython: create C++ source
                             )],
      )
