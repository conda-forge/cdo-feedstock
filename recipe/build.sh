#!/bin/bash

# The `ACCEPT_USE_OF_DEPRECATED_PROJ_API_H` is a temporary solution and won't work with proj4 7.
export CFLAGS="-DACCEPT_USE_OF_DEPRECATED_PROJ_API_H=1  ${CFLAGS}"

if [[ $(uname) == 'Darwin' ]]; then
  export CXXFLAGS="-fPIC -DPIC -g -O2 -std=c++11 -stdlib=libc++ ${CFLAGS}"
  export LDFLAGS="${LDFLAGS} -fopenmp"
  ARGS=""
elif [[ $(uname) == Linux ]]; then
  export CXXFLAGS="-fPIC -DPIC -g -O2 -std=c++11 -fopenmp ${CFLAGS}"
  export LDFLAGS="-L${PREFIX}/lib -lhdf5 ${LDFLAGS}"
  ARGS="--disable-dependency-tracking"
fi

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
            --with-ossp-uuid=${PREFIX} \
            ${ARGS}

make
make check
make install
