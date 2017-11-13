FROM nvidia/cuda:8.0-devel-ubuntu14.04
MAINTAINER Florian Weik <fweik@icp.uni-stuttgart.de>
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update && apt-get install -y \
    apt-utils \
    build-essential \
    curl \
    openmpi-bin \
    lcov \
    libfftw3-dev \
    libboost-dev libboost-serialization-dev libboost-mpi-dev libboost-filesystem-dev libboost-test-dev \
    python python-numpy python-h5py python-enum \
    git \
    pep8 pylint\
    python-vtk \
    python-pip \
    libpython-dev \
    libhdf5-openmpi-dev \
    doxygen \
    vim \
&& pip2 install cython sphinx sphinxcontrib-bibtex numpydoc --upgrade \
&& apt-get clean \
&& rm -rf /var/lib/apt/lists/* \
&& rm /usr/lib/pymodules/python2.7/vtk/vtk{Rendering,VolumeRendering,Hybrid,Widgets,Charts,Geovis,Infovis,TextAnalysis,Views,Parallel}Python.so

RUN cd /usr/local \
&& curl -sL https://cmake.org/files/v3.1/cmake-3.1.0-Linux-x86_64.tar.gz | tar --strip-components=1 -xz

RUN useradd -m espresso && usermod -a -G www-data espresso
USER espresso
WORKDIR /home/espresso
