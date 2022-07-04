#!/bin/bash#!/bin/bash

if [[ $(uname) == 'Darwin' ]]; then
  export CC=clang
  export CXX=clang++
  export CFLAGS="${CFLAGS} -lm"
  export CXXFLAGS="-fPIC -DPIC -g -O2 ${CFLAGS}"
  export CPP=clang-cpp
  export LDFLAGS="${LDFLAGS} -fopenmp"
  export LIBS="-ljson-c"
  ARGS=""
elif [[ $(uname) == Linux ]]; then
  export CXXFLAGS="-fPIC -DPIC -g -O2 -std=c++14 -fopenmp ${CFLAGS}"
  export CFLAGS="${CFLAGS} -lm"
  export LDFLAGS="-L${PREFIX}/lib -lhdf5 ${LDFLAGS}"
  export LIBS="-ljson-c"
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
            --with-util-linux-uuid=${PREFIX} \
            --disable-ossp-uuid \
            --with-cmor=${PREFIX} \
            --with-magics=${PREFIX} \
            ${ARGS}

make
make check
make install
