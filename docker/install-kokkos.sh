#!/bin/sh

set -e

cd /tmp

kokkos_version="4.3.00"
curl -Lo ./kokkos-${kokkos_version}.tar.gz https://github.com/kokkos/kokkos/archive/refs/tags/${kokkos_version}.tar.gz
tar xfz ./kokkos-${kokkos_version}.tar.gz
rm ./kokkos-${kokkos_version}.tar.gz
cd kokkos-${kokkos_version}/
mkdir build
cd build/
cmake ..  -D Kokkos_ENABLE_CUDA=OFF -DKokkos_ENABLE_OPENMP=ON -D CMAKE_POSITION_INDEPENDENT_CODE=ON
make -j $(nproc) install
cd
rm -r /tmp/kokkos-${kokkos_version}
ldconfig
