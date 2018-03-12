FROM nvidia/cuda:8.0-devel-ubuntu14.04
MAINTAINER Florian Weik <fweik@icp.uni-stuttgart.de>
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update && apt-get install -y \
    apt-utils \
    build-essential \
    curl \
    lcov \
    libbz2-dev \
    libfftw3-dev \
    python python-numpy python-enum \
    git \
    pep8 pylint\
    python-vtk \
    python-pip \
    libpython-dev \
    doxygen \
    vim \
&& pip2 install cython sphinx sphinxcontrib-bibtex numpydoc --upgrade \
&& apt-get clean \
&& rm -rf /var/lib/apt/lists/* \
&& rm /usr/lib/pymodules/python2.7/vtk/vtkRenderingPython.so /usr/lib/pymodules/python2.7/vtk/vtkVolumeRenderingPython.so /usr/lib/pymodules/python2.7/vtk/vtkHybridPython.so /usr/lib/pymodules/python2.7/vtk/vtkWidgetsPython.so /usr/lib/pymodules/python2.7/vtk/vtkChartsPython.so /usr/lib/pymodules/python2.7/vtk/vtkGeovisPython.so /usr/lib/pymodules/python2.7/vtk/vtkInfovisPython.so /usr/lib/pymodules/python2.7/vtk/vtkViewsPython.so /usr/lib/pymodules/python2.7/vtk/vtkParallelPython.so

# CMake
RUN cd /usr/local \
&& curl -sL https://cmake.org/files/v3.6/cmake-3.6.3-Linux-x86_64.tar.gz | tar --strip-components=1 -xz

# Intel Compiler
COPY intel.cfg /tmp/
RUN cd /tmp \
 && mkdir intel \
 && cd intel \
 && curl -sL http://registrationcenter-download.intel.com/akdlm/irc_nas/tec/4933/l_compxe_2015.1.133.tgz | tar --strip-components=1 -xz \
 && USER=root ./install.sh --silent /tmp/intel.cfg \
 && cd \
 && rm -r /tmp/intel

ENV CC=/opt/intel/bin/icc CXX=/opt/intel/bin/icpc PATH="/opt/intel/bin:${PATH}"

# Intel MPI
COPY intel-mpi.cfg /tmp/
RUN cd /tmp \
 && mkdir intel-mpi \
 && cd intel-mpi \
 && curl -sL http://registrationcenter-download.intel.com/akdlm/irc_nas/tec/12414/l_mpi_2018.1.163.tgz | tar --strip-components=1 -xz \
 && ./install.sh --silent /tmp/intel-mpi.cfg \
 && ln -s /opt/intel-mpi/compilers_and_libraries_2018.1.163/linux/mpi/intel64/bin/mpicxx /opt/intel-mpi/compilers_and_libraries_2018.1.163/linux/mpi/intel64/bin/mpic++ \
 && cd \
 && rm -r /tmp/intel-mpi

ENV PATH="/opt/intel-mpi/compilers_and_libraries_2018.1.163/linux/mpi/intel64/bin:${PATH}" I_MPI_ROOT=/opt/intel-mpi/compilers_and_libraries_2018.1.163/linux/mpi

# Boost
RUN cd /tmp \
 && mkdir boost \
 && cd boost \
 && curl -L http://downloads.sourceforge.net/project/boost/boost/1.61.0/boost_1_61_0.tar.bz2 | tar xj \
 && cd boost_1_61_0 \
 && echo 'using mpi ;' > tools/build/src/user-config.jam \
 && ./bootstrap.sh \
 && ./b2 -j $(nproc) toolset=intel install --prefix=/opt/boost \
 && cd \
 && rm -r /tmp/boost

ENV BOOST_ROOT=/opt/boost

RUN useradd -m espresso && usermod -a -G www-data espresso
USER espresso
WORKDIR /home/espresso
