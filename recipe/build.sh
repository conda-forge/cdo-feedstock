#!/bin/bash

if [[ $(uname) == 'Darwin' ]]; then
  export LIBRARY_SEARCH_VAR=DYLD_FALLBACK_LIBRARY_PATH
elif [[ $(uname) == 'Linux' ]]; then
  export LIBRARY_SEARCH_VAR=LD_LIBRARY_PATH
fi

export CPPFLAGS=-I$PREFIX/include
export LDFLAGS=-L$PREFIX/lib
./configure --prefix=$PREFIX \
            --disable-debug \
            --disable-dependency-tracking \
            --with-jasper=$PREFIX \
            --with-hdf5=$PREFIX \
            --with-netcdf=$PREFIX \
            --with-proj=$PREFIX

make
eval ${LIBRARY_SEARCH_VAR}=$PREFIX/lib make check
make install
