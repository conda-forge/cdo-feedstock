#!/bin/bash

if [[ $(uname) == 'Darwin' ]]; then
  OPTS="--disable-openmp"
elif [[ $(uname) == 'Linux' ]]; then
  export CFLAGS="-fPIC -fopenmp $CFLAGS"
  OPTS="--with-libxml2=$PREFIX --with-curl=$PREFIX --with-proj=$PREFIX --with-fftw3 --with-grib_api=$PREFIX --with-udunits2=$PREFIX --with-netcdf=$PREFIX --with-hdf5=$PREFIX"
fi

export LDFLAGS="-L$PREFIX/lib $LDFLAGS"
export CPPFLAGS="-I$PREFIX/include $CPPFLAGS"

./configure --prefix=$PREFIX \
            --disable-debug \
            --disable-dependency-tracking \
            $OPTS

make
# See https://github.com/conda-forge/cdo-feedstock/pull/8#issuecomment-257273909
# Hopefully https://github.com/conda-forge/hdf5-feedstock/pull/48 will fix this.
# eval ${LIBRARY_SEARCH_VAR}=$PREFIX/lib make check
make check CDO="${SRC_DIR}/src/cdo -L"
make install
