# More *python* way using Cython, compared with `cyth.pyx`. 
# Use two seperate 1-d arrays instead of one 2-d matrix.
# No speedups.

from __future__ import division
import numpy as np

cimport numpy as np
cimport cython
from libc.math cimport sqrt

DTYPE = np.double
ctypedef double DTYPE_t

@cython.cdivision(True)
@cython.wraparound(False)
@cython.boundscheck(False)
cdef void cy_compute_F(int wN, 
                       np.ndarray[DTYPE_t, ndim=1] wr0, 
                       np.ndarray[DTYPE_t, ndim=1] wr1, 
                       np.ndarray[DTYPE_t, ndim=1] wF0, 
                       np.ndarray[DTYPE_t, ndim=1] wF1,
                       np.ndarray[DTYPE_t, ndim=1] wm, 
                       np.ndarray[DTYPE_t, ndim=1] ws3):

    cdef int i, j;
    cdef double sx, sy, Fx, Fy, s3, tmp;
    
    wF0[:] = 0.0
    wF1[:] = 0.0
    for i in range(wN):
        for j in range(i+1, wN):
            sx = wr0[j] - wr0[i];
            sy = wr1[j] - wr1[i];

            s3 = sqrt(sx*sx + sy*sy);
            s3 *= s3 * s3;

            tmp = wm[i] * wm[j] / s3;
            Fx = tmp * sx;
            Fy = tmp * sy;

            wF0[i] += Fx;
            wF1[i] += Fy;

            wF0[j] -= Fx;
            wF1[j] -= Fy;


@cython.wraparound(False)
cdef cy_evolve_c(int wthreads, 
                 double wdt, 
                 int steps, 
                 int wN, 
                 np.ndarray[DTYPE_t, ndim=1] wm,
                 np.ndarray[DTYPE_t, ndim=1] wr0, 
                 np.ndarray[DTYPE_t, ndim=1] wr1, 
                 np.ndarray[DTYPE_t, ndim=1] wv0, 
                 np.ndarray[DTYPE_t, ndim=1] wv1, 
                 np.ndarray[DTYPE_t, ndim=1] wF0, 
                 np.ndarray[DTYPE_t, ndim=1] wF1,
                 np.ndarray[DTYPE_t, ndim=1] ws0, 
                 np.ndarray[DTYPE_t, ndim=1] ws1, 
                 np.ndarray[DTYPE_t, ndim=1] ws3):

    cdef int jj, ii, i, j;
    cdef double sx, sy, Fx, Fy, s3, tmp;
    
    for jj in range(steps):
        cy_compute_F(wN, wr0, wr1, wF0, wF1, wm, ws3)
            
        for ii in range(wN):
            wv0[ii] += wF0[ii] * wdt / wm[ii];
            wv1[ii] += wF1[ii] * wdt / wm[ii];

            wr0[ii] += wv0[ii] * wdt;
            wr1[ii] += wv1[ii] * wdt;


def evolve(w, steps):
    cy_evolve_c(w.threads, w.dt, steps, w.N, w.m, 
                w.r[:,0], w.r[:,1], w.v[:,0], w.v[:,1],
                w.F[:,0], w.F[:,1], w.s[:,0], w.s[:,1], w.s3)
