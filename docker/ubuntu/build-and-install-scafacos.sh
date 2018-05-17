cd /tmp &&
git clone git://github.com/RudolfWeeber/scafacos --branch for_use_with_espresso_dipoles &&
cd scafacos &&
git submodule init &&
git submodule update &&
./bootstrap &&
./configure --with-internal-pfft --with-internal-pnfft --enable-fcs-solvers=direct,pnfft,p2nfft,p3m --enable-shared --disable-fcs-fortran &&
make -j `nproc` &&
make install &&
cd &&
rm -rf /tmp/scafacos &&
ldconfig

