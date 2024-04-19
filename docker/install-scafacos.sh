#!/bin/sh

set -e

cd /tmp

git clone --recursive --branch dipoles https://github.com/scafacos/scafacos.git
cd scafacos

# get a stable revision in the dipoles branch
git checkout -b patches 066f753f0572c7397508231cb4fc9432d5aeaf04
# fix diagnostics from GCC >= 10.0 (scafacos/scafacos#31)
git cherry-pick -n ef7268c3c75cfbdde02392d7af9dfb11a0a386fd
# MMM2D energy bugfix (scafacos/scafacos#32)
git cherry-pick -n 4cd4699d33ad173484512897ceff41debbb28793
# remove deprecated MPI functions (scafacos/scafacos@v1.0.2)
git cherry-pick -n 39b68e77ec9619282eaf63b986a4f9ef532e6609
git cherry-pick -n be416261bc0ff9c7406b4114515c97af73a70f47
# Ewald tuning bugfix (scafacos/scafacos#36)
git fetch origin pull/36/head
git cherry-pick -n a752a05761f6624076373d7a6c33d1c80c2f85eb
# remove unused Cython file that fails to install
sed -i 's/ scafacos.pyx / /' python/Makefile.am

./bootstrap
mkdir build
cd build
../configure --enable-shared \
             --enable-portable-binary \
             --with-gcc-arch=x86_64 \
             --enable-fcs-dipoles \
             --enable-fcs-solvers=direct,p2nfft,p3m,ewald \
             --disable-fcs-fortran \
             --with-internal-fftw=no \
             --with-internal-pfft=no \
             --with-internal-pnfft=yes \
             --prefix=/usr/local
make -j $(nproc)
make install
cd
rm -r /tmp/scafacos
ldconfig
