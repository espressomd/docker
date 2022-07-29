#!/bin/bash

set -e

cd /tmp

pnfft_version="a0bb24b8fa8af59c9e599b1cc3914586636d9125"
curl -Lo ./pnfft-${pnfft_version}.tar.gz https://github.com/mpip/pnfft/archive/${pnfft_version}.tar.gz
tar xfz pnfft-${pnfft_version}.tar.gz
cd pnfft-${pnfft_version}

./bootstrap.sh
mkdir build
cd build
../configure --prefix=/usr/local
make -j $(nproc)
make install
cd
rm -r /tmp/pnfft-${pnfft_version}.tar.gz /tmp/pnfft-${pnfft_version}
ldconfig
