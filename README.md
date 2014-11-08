Cython Example
==============

Recently I read a wonderful series of [posts](https://www.crumpington.com/blog/2014/10-19-high-performance-python-extensions-part-1.html) about using Python C API to speedup python scripts. But I'm not a C fun and I used [Cython]() to ease the work. So I wonder how much could I get using Cython instead of Python C API?

On the last [post](https://www.crumpington.com/blog/2014/10-24-high-performance-python-extensions-part-3.html) of the series, I found a Cython version implemented by Matthew Honnibal [here](http://honnibal.wordpress.com/2014/10/21/writing-c-in-cython/). It is very fast but too *C++*. I hope I can write another but more *python* version.

At last, I got an cython implementation that operates on numpy ndarrays. The speed is comparable to Matthew's work, but looks more streight forward. I put the result below with no explaintion, but `Cython` corresponds to Matthew's implementation and Cython PR is my *python-er* implementation.


Cython PR (1): 8012 steps/sec
    max(delta r): 0.0
    max(delta v): 8.7e-18
    max(delta F): 8.9e-16

Python (1): 125 steps/sec
    max(delta r): 0.0
    max(delta v): 0.0
    max(delta F): 0.0


C Simple 1 (1): 6177 steps/sec
    max(delta r): 0.0
    max(delta v): 2.2e-16
    max(delta F): 1.8e-15


C Simple 2 (1): 9158 steps/sec
    max(delta r): 0.0
    max(delta v): 0.0
    max(delta F): 4.4e-16


C SIMD 1 (1): 9057 steps/sec
    max(delta r): 0.0
    max(delta v): 0.0
    max(delta F): 6.7e-16


Cython (1): 8198 steps/sec


Cython PR (1): 8012 steps/sec
    max(delta r): 0.0
    max(delta v): 8.7e-18
    max(delta F): 8.9e-16


Cython PR1d (1): 7448 steps/sec
    max(delta r): 0.0
    max(delta v): 4.4e-16
    max(delta F): 8.9e-16


Cython PR1dV (1): 7546 steps/sec
    max(delta r): 0.0
    max(delta v): 2.8e-17
    max(delta F): 1.8e-15


C OpenMP 1 (1): 8255 steps/sec
    max(delta r): 0.0
    max(delta v): 5.6e-17
    max(delta F): 1.8e-15


C SIMD OpenMP 1 (1): 8283 steps/sec
    max(delta r): 0.0
    max(delta v): 1.4e-17
    max(delta F): 8.9e-16


C OpenMP 1 (2): 12287 steps/sec
    max(delta r): 0.0
    max(delta v): 8.9e-16
    max(delta F): 7.1e-15


C SIMD OpenMP 1 (2): 12209 steps/sec
    max(delta r): 0.0
    max(delta v): 2.2e-16
    max(delta F): 1.8e-15


C OpenMP 1 (3): 7845 steps/sec
    max(delta r): 2.2e-16
    max(delta v): 2.2e-16
    max(delta F): 4.4e-16


C SIMD OpenMP 1 (3): 6903 steps/sec
    max(delta r): 0.0
    max(delta v): 1.4e-17
    max(delta F): 1.3e-15


C OpenMP 1 (4): 7085 steps/sec
    max(delta r): 0.0
    max(delta v): 2.2e-16
    max(delta F): 1.4e-14


C SIMD OpenMP 1 (4): 6983 steps/sec
    max(delta r): 0.0
    max(delta v): 2.2e-16
    max(delta F): 7.1e-15
