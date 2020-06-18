#!/bin/bash#!/bin/bash

if [[ $(uname) == 'Darwin' ]]; then
  export CXXFLAGS="-fPIC -DPIC -g -O2 -std=c++11 -stdlib=libc++ ${CFLAGS}"
  ARGS="--disable-openmp"
elif [[ $(uname) == Linux ]]; then
  export CXXFLAGS="-fPIC -DPIC -g -O2 -std=c++11 -fopenmp ${CFLAGS}"
  ARGS="--disable-dependency-tracking"
fi
  export LDFLAGS="-L${PREFIX}/lib -lhdf5 ${LDFLAGS}"
  export LIBS="-ljson-c"
./configure --prefix=${PREFIX} \
            --host=${HOST} \
            --build=${BUILD} \
            --disable-debug \
            --with-fftw3 \
            --with-libxml2=${PREFIX} \
            --with-curl=${PREFIX} \
            --with-proj=${PREFIX} \
            --with-eccodes=${PREFIX} \
            --with-udunits2=${PREFIX} \
            --with-netcdf=${PREFIX} \
            --with-hdf5=${PREFIX} \
            --with-util-linux-uuid=${PREFIX} \
            --disable-ossp-uuid \
            --with-cmor=${PREFIX} \
            ${ARGS}

make
make check
make install
