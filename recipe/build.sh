#!/bin/bash

if [[ $(uname) == 'Darwin' ]]; then
  export CPP=clang-cpp
  export CXXFLAGS="${CXXFLAGS} -D_LIBCPP_DISABLE_AVAILABILITY"
  ARGS=""
elif [[ $(uname) == Linux ]]; then
  export CXXFLAGS="-fPIC -DPIC -g -O2 ${CFLAGS}"
  export LDFLAGS="-L${PREFIX}/lib -lhdf5 ${LDFLAGS}"
  ARGS="--disable-dependency-tracking"
fi

# Use the Python from the build environment for the tests: rattler-build sets
# PYTHON to $PREFIX/bin/python, which gives shebang lines that are too long
# for Linux because $PREFIX is padded.
export PYTHON="${BUILD_PREFIX}/bin/python"

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
            --enable-openmp \
            ${ARGS}

make -j${CPU_COUNT}
if [[ "${CONDA_BUILD_CROSS_COMPILATION:-}" != "1" || "${CROSSCOMPILING_EMULATOR}" != "" ]]; then
    make -j${CPU_COUNT} check
fi
make install
