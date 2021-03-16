#!/bin/bash

set -e

cd /tmp
git clone --recursive git://github.com/scafacos/scafacos --branch dipoles
cd scafacos
./bootstrap
./configure --enable-shared --enable-portable-binary \
	--with-internal-pfft --with-internal-pnfft \
	--enable-fcs-solvers=direct,pnfft,p2nfft,p3m,ewald \
	--disable-fcs-fortran --enable-fcs-dipoles
make -j `nproc`
make install
cd
rm -rf /tmp/scafacos
ldconfig
