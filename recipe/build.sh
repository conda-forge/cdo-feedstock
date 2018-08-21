#!/bin/bash

if [[ $(uname) == 'Darwin' ]]; then

  ./configure --prefix=$PREFIX \
              --disable-debug \
              --disable-dependency-tracking
elif [[ $(uname) == 'Linux' ]]; then

  export CFLAGS="-fPIC -DPIC $CFLAGS"
  export CXXFLAGS="-fPIC -DPIC -g -O2 -std=c++11 -fopenmp $CFLAGS"
  export LDFLAGS="-L$PREFIX/lib -lhdf5 $LDFLAGS"
  export CPPFLAGS="-I$PREFIX/include $CPPFLAGS"
  ./configure --prefix=$PREFIX \
              --disable-debug \
              --with-fftw3 \
              --disable-dependency-tracking \
              --with-libxml2=$PREFIX \
              --with-curl=$PREFIX \
              --with-proj=$PREFIX \
              --with-eccodes=$PREFIX \
              --with-udunits2=$PREFIX \
              --with-netcdf=$PREFIX \
              --with-hdf5=$PREFIX \
              --with-cmor=$PREFIX \
              --with-ossp-uuid=$PREFIX 
fi

make
# See https://github.com/conda-forge/cdo-feedstock/pull/8#issuecomment-257273909
# Hopefully https://github.com/conda-forge/hdf5-feedstock/pull/48 will fix this.
# eval ${LIBRARY_SEARCH_VAR}=$PREFIX/lib make check
make check CDO="${SRC_DIR}/src/cdo -L"
make install
