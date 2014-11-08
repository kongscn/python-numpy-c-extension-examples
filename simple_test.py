
import os
import time
import multiprocessing as mp

import numpy as np

import lib


def test_fn(evolve_fn, name=None, steps=1000, dt=1e-3, bodies=101, threads=1):
    print "\n"
    if name is None:
        name = evolve_fn.func_name
    # Test the speed of the evolution function. 
    w = lib.World(bodies, threads=threads, dt=dt)
    
    t0 = time.time()
    evolve_fn(w, steps)
    t1 = time.time()
    print "{0} ({1}): {2} steps/sec".format(
        name, threads, int(steps / (t1 - t0)))
    
    # Compare the evolution function to the pure python version. 
    w1 = lib.World(5, threads=threads, dt=dt)
    w2 = w1.copy()
    
    lib.evolve(w1, 2)
    evolve_fn(w2, 2)
    
    def f(name, verbose=False):
        wA = w1
        wB = w2
        dvmax = eval("np.absolute(wA.{0} - wB.{0}).max()".format(name))
        print("    max(delta {0}): {1:2.2}".format(name, dvmax))
        if verbose:
            print(eval("wA.%s" % name))
            print("CHeck")
            print(eval("wB.%s" % name))
        
    f("r")
    f("v")
    f("F")

def test_cythfn(evolve_fn, name, steps=1000, dt=1e-3, bodies=101, threads=1):
    print "\n"

    # Test the speed of the evolution function. 
    w = lib.cyth.World(bodies, threads=threads, dt=dt)
    
    t0 = time.time()
    evolve_fn(w, steps)
    t1 = time.time()
    print "{0} ({1}): {2} steps/sec".format(
        name, threads, int(steps / (t1 - t0)))

if __name__ == "__main__":
    # Single CPU only tests. 

    test_fn(lib.evolve_cythpr, steps=32000)
    test_fn(lib.evolve_cythpr1d, "Cython 1d", steps=32000)
    test_fn(lib.evolve_cythpr1dv, "Cython 1dv", steps=32000)