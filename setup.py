#!/usr/bin/env python

from distutils.core import setup, Extension
from Cython.Distutils import build_ext

setup(name             = "numpy_c_ext_example",
      version          = "1.0",
      description      = "Example code for blog post.",
      author           = "J. David Lee",
      author_email     = "contact@crumpington.com",
      maintainer       = "contact@crumpington.com",
      url              = "https://www.crumpington.com",
      cmdclass = {'build_ext': build_ext},
      ext_modules      = [
          Extension(
              'lib.simple1', ['src/simple1.c'],
              extra_compile_args=["-Ofast", "-march=native"]),
          Extension(
              'lib.simple2', ['src/simple2.c'],
              extra_compile_args=["-Ofast", "-march=native"]),
          Extension(
              'lib.simd1', ['src/simd1.c'],
              extra_compile_args=["-Ofast", "-march=native"]),
          Extension(
              'lib.omp1', ['src/omp1.c'],
              extra_compile_args=["-Ofast", "-march=native", "-fopenmp"],
              libraries=["gomp"]),
          Extension(
              'lib.simdomp1', ['src/simdomp1.c'],
              extra_compile_args=["-Ofast", "-march=native", "-fopenmp"],
              libraries=["gomp"]),
          Extension(
                "lib.cyth",
                ["src/cyth.pyx"],
          ),
          Extension(
                "lib.cythpr",
                ["src/cythpr.pyx"],
                extra_compile_args=["-Ofast", "-march=native"],
          ),
          Extension(
                "lib.cythpr1d",
                ["src/cythpr1d.pyx"],
                extra_compile_args=["-Ofast", "-march=native"],
          ),
          Extension(
                "lib.cythpr1dv",
                ["src/cythpr1dv.pyx"],
                extra_compile_args=["-Ofast", "-march=native"],
          ),
      ], 
      
)
