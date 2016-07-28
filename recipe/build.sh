#!/bin/bash

OPTS=""
if [[ $(uname) == 'Darwin' ]]; then
  export LIBRARY_SEARCH_VAR=DYLD_FALLBACK_LIBRARY_PATH
  export OPTS="--disable-openmp"
elif [[ $(uname) == 'Linux' ]]; then
  export LIBRARY_SEARCH_VAR=LD_LIBRARY_PATH
  export CFLAGS="-fPIC -fopenmp $CFLAGS"
fi

export LDFLAGS="-L$PREFIX/lib $LDFLAGS"
export CPPFLAGS="-I$PREFIX/include $CPPFLAGS"

./configure --prefix=$PREFIX \
            --disable-debug \
            --disable-dependency-tracking \
            --with-fftw3 \
            --with-jasper=$PREFIX \
            --with-grib_api=$PREFIX \
            --with-hdf5=$PREFIX \
            --with-netcdf=$PREFIX \
            --with-proj=$PREFIX \
            --with-udunits2=$PREFIX \
            --with-curl=$PREFIX \
            --with-libxml2=$PREFIX \
            $OPTS

make
eval ${LIBRARY_SEARCH_VAR}=$PREFIX/lib make check
make install
