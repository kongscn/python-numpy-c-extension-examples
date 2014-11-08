# More *python* way using Cython, compared with `cyth.pyx`. 
# Use one 1-d arrays instead of one 2-d matrix.
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
                       np.ndarray[DTYPE_t, ndim=1] wr, 
                       np.ndarray[DTYPE_t, ndim=1] wF, 
                       np.ndarray[DTYPE_t, ndim=1] wm, 
                       np.ndarray[DTYPE_t, ndim=1] ws3):

    cdef int i, j;
    cdef int ix, iy, jx, jy;
    cdef double sx, sy, Fx, Fy, s3, tmp;
    
    wF[:] = 0.0
    for i in range(wN):
        ix = i*2;
        iy = ix + 1;
        for j in range(i+1, wN):
            jx = 2*j;
            jy = jx + 1;
            sx = wr[jx] - wr[ix];
            sy = wr[jy] - wr[iy];

            s3 = sqrt(sx*sx + sy*sy);
            s3 *= s3 * s3;

            tmp = wm[i] * wm[j] / s3;
            Fx = tmp * sx;
            Fy = tmp * sy;

            wF[ix] += Fx;
            wF[iy] += Fy;

            wF[jx] -= Fx;
            wF[jy] -= Fy;


@cython.wraparound(False)
cdef cy_evolve_c(int wthreads, 
                 double wdt, 
                 int steps, 
                 int wN, 
                 np.ndarray[DTYPE_t, ndim=1] wm,
                 np.ndarray[DTYPE_t, ndim=1] wr, 
                 np.ndarray[DTYPE_t, ndim=1] wv, 
                 np.ndarray[DTYPE_t, ndim=1] wF, 
                 np.ndarray[DTYPE_t, ndim=1] ws, 
                 np.ndarray[DTYPE_t, ndim=1] ws3):
    """Evolve the world, w, through the given number of steps."""
    cdef int jj, ii, i, j;
    cdef int xidx, yidx;
    cdef double sx, sy, Fx, Fy, s3, tmp;
    
    for jj in range(steps):
        cy_compute_F(wN, wr, wF, wm, ws3)
            
        for ii in range(wN):
            xidx = ii*2;
            yidx = xidx + 1;
            wv[xidx] += wF[xidx] * wdt / wm[ii];
            wv[yidx] += wF[yidx] * wdt / wm[ii];

            wr[xidx] += wv[xidx] * wdt;
            wr[yidx] += wv[yidx] * wdt;

def evolve(w, steps):
    cy_evolve_c(w.threads, w.dt, steps, w.N, w.m, 
                w.r.ravel(), w.v.ravel(),
                w.F.ravel(), w.s.ravel(), w.s3)
