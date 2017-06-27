#!/bin/bash

OPTS=""

if [[ $(uname) == 'Darwin' ]]; then
  OPTS="--disable-openmp"
elif [[ $(uname) == 'Linux' ]]; then
  OPTS="--with-grib_api=$PREFIX --with-fftw3 --with-libxml2=$PREFIX --with-curl=$PREFIX --with-proj=$PREFIX --with-udunits2=$PREFIX --with-netcdf=$PREFIX --with-hdf5=$PREFIX"
  export CFLAGS="-fPIC -fopenmp $CFLAGS"
  export LDFLAGS="-L$PREFIX/lib -lhdf5 $LDFLAGS"
  export CPPFLAGS="-I$PREFIX/include $CPPFLAGS"
fi

./configure --prefix=$PREFIX \
            --disable-debug \
            --disable-dependency-tracking \
            $OPTS

make
eval ${LIBRARY_SEARCH_VAR}=$PREFIX/lib make check
make install
