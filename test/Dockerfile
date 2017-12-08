ARG image
From $image 
ENV make_check false
ENV myconfig maxset
RUN /bin/bash -c 'git clone https://github.com/espressomd/espresso; cd espresso; maintainer/travis/build_cmake.sh'
