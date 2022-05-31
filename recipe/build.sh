#!/bin/bash

if [[ $(uname) == 'Darwin' ]]; then
  export CC=clang
  export CXX=clang++
  export CXXFLAGS="-fPIC -DPIC -g -O2 ${CFLAGS}"
  export CPP=clang-cpp
  export LDFLAGS="${LDFLAGS} -fopenmp"
  ARGS=""
elif [[ $(uname) == Linux ]]; then
  export CXXFLAGS="-fPIC -DPIC -g -O2 -fopenmp ${CFLAGS}"
  export LDFLAGS="-L${PREFIX}/lib -lhdf5 ${LDFLAGS}"
  ARGS="--disable-dependency-tracking"
fi

# Get an updated config.sub and config.guess
cp $BUILD_PREFIX/share/gnuconfig/config.* .

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
            --with-magics=${PREFIX} \
            ${ARGS}

make
make check
make install
