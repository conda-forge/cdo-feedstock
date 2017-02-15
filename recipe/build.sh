#!/bin/bash

if [[ $(uname) == 'Darwin' ]]; then

  ./configure --prefix=$PREFIX \
              --disable-debug \
              --disable-dependency-tracking \
              --disable-openmp \
              --with-netcdf=$PREFIX

elif [[ $(uname) == 'Linux' ]]; then
  export CFLAGS="-fPIC -fopenmp $CFLAGS"
  export LDFLAGS="-L$PREFIX/lib $LDFLAGS"
  export CPPFLAGS="-I$PREFIX/include $CPPFLAGS"
  ./configure --prefix=$PREFIX \
              --disable-debug \
              --with-fftw3 \
              --disable-dependency-tracking \
              --with-libxml2=$PREFIX \
              --with-curl=$PREFIX \
              --with-proj=$PREFIX \
              --with-grib_api=$PREFIX \
              --with-udunits2=$PREFIX \
              --with-netcdf=$PREFIX \
              --with-hdf5=$PREFIX
fi

make
# See https://github.com/conda-forge/cdo-feedstock/pull/8#issuecomment-257273909
# Hopefully https://github.com/conda-forge/hdf5-feedstock/pull/48 will fix this.
# eval ${LIBRARY_SEARCH_VAR}=$PREFIX/lib make check
make check CDO="${SRC_DIR}/src/cdo -L"
make install
