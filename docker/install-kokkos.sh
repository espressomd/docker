#!/bin/sh

set -e

cd /tmp

git clone -b 4.3.00 https://github.com/kokkos/kokkos
cd kokkos/
mkdir build
cd build/
cmake ..  -D Kokkos_ENABLE_CUDA=OFF -DKokkos_ENABLE_OPENMP=ON
make -j $(nproc) install
cd
rm -r /tmp/kokkos
ldconfig
