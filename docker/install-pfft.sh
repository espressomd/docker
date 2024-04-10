#!/bin/sh

set -e

cd /tmp

pfft_version="e4cfcf9902d0ef82cb49ec722040932b6b598c71"
curl -Lo ./pfft-${pfft_version}.tar.gz https://github.com/mpip/pfft/archive/${pfft_version}.tar.gz
tar xfz pfft-${pfft_version}.tar.gz
cd pfft-${pfft_version}

./bootstrap.sh
mkdir build
cd build
../configure --prefix=/usr/local --enable-portable-binary --with-gcc-arch=x86_64
make -j $(nproc)
make install
cd
rm -r /tmp/pfft-${pfft_version}.tar.gz /tmp/pfft-${pfft_version}
ldconfig
