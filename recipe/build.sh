#!/bin/bash

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
  export CXXFLAGS="-fPIC -DPIC -g -O2 ${CFLAGS}"
  export LDFLAGS="-L${PREFIX}/lib -lhdf5 ${LDFLAGS}"
  export LIBS="-ljson-c -luuid"
  export CFLAGS="-lm ${CFLAGS}"
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
	    --with-libuuid \
	    --with-cmor=${PREFIX} \
            --with-magics=${PREFIX} \
            --enable-openmp \
            ${ARGS}
cat config.log
make
if [[ "${CONDA_BUILD_CROSS_COMPILATION:-}" != "1" || "${CROSSCOMPILING_EMULATOR}" != "" ]]; then
    make check
fi
make install
