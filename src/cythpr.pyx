# More *python* way using Cython, compared with `cyth.pyx`. 

from __future__ import division
import numpy as np

cimport numpy as np
cimport cython
from libc.math cimport sqrt

DTYPE = np.double
ctypedef np.double_t DTYPE_t

@cython.cdivision(True)
@cython.wraparound(False)
@cython.boundscheck(False)
cdef void cy_compute_F(int wN, 
                       np.ndarray[DTYPE_t, ndim=2] ws, 
                       np.ndarray[DTYPE_t, ndim=2] wr, 
                       np.ndarray[DTYPE_t, ndim=2] wF, 
                       np.ndarray[DTYPE_t, ndim=1] wm, 
                       np.ndarray[DTYPE_t, ndim=1] ws3):
    cdef int i, j;
    cdef double sx, sy, Fx, Fy, s3, tmp;

    wF[:] = 0.0
    for i in range(wN):
        for j in range(i+1, wN):
            sx = wr[j, 0] - wr[i, 0];
            sy = wr[j, 1] - wr[i, 1];

            s3 = sqrt(sx*sx + sy*sy);
            s3 *= s3 * s3;

            tmp = wm[i] * wm[j] / s3;
            Fx = tmp * sx;
            Fy = tmp * sy;

            wF[i, 0] += Fx;
            wF[i, 1] += Fy;

            wF[j, 0] -= Fx;
            wF[j, 1] -= Fy;


@cython.wraparound(False)
cdef cy_evolve_c(int wthreads, 
                 double wdt, 
                 int steps, 
                 int wN, 
                 np.ndarray[DTYPE_t, ndim=1] wm,
                 np.ndarray[DTYPE_t, ndim=2] wr, 
                 np.ndarray[DTYPE_t, ndim=2] wv, 
                 np.ndarray[DTYPE_t, ndim=2] wF, 
                 np.ndarray[DTYPE_t, ndim=2] ws, 
                 np.ndarray[DTYPE_t, ndim=1] ws3):
    
    cdef int jj, ii;
    cdef double sx, sy, Fx, Fy, s3, tmp;
    
    for jj in xrange(steps):
        cy_compute_F(wN, ws, wr, wF, wm, ws3)
            
        for ii in xrange(wN):
            wv[ii, 0] += wF[ii, 0] * wdt / wm[ii];
            wv[ii, 1] += wF[ii, 1] * wdt / wm[ii];

            wr[ii, 0] += wv[ii, 0] * wdt;
            wr[ii, 1] += wv[ii, 1] * wdt;


def evolve(w, steps):
    cy_evolve_c(w.threads, w.dt, steps, w.N, w.m, w.r, w.v, w.F, w.s, w.s3)
