FROM ubuntu:14.04

RUN apt-get update &&\
    apt-get install -y software-properties-common python-software-properties &&\
    add-apt-repository ppa:ubuntu-toolchain-r/test &&\
    apt-get update &&\
    apt-get install -y cmake zlib1g-dev libssl-dev uuid-dev g++-4.9 git curl unzip dh-autoreconf mpi-default-bin mpi-default-dev build-essential &&\
    update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-4.9 60

RUN git clone https://github.com/google/protobuf.git &&\
    cd protobuf &&\
    git checkout 3.0.x &&\
    ./autogen.sh &&\
    ./configure --prefix=/usr/local --with-pic &&\
    make -j4 &&\
    make install

ADD . /GenomicsDB

RUN cd /GenomicsDB &&\
    cmake /GenomicsDB -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=/usr/local -DBUILD_JAVA=0 -DPROTOBUF_LIBRARY=/usr/local &&\
    make -j8 &&\
    make install

RUN rm -rf /GenomicsDB /protobuf && apt-get clean

