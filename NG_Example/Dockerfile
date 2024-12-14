FROM docker.io/nvidia/cuda:11.7.1-devel-ubi8 AS devel 

# Establish the versions of the libraries and tools used in this container
ARG GCC_TOOLSET_VERSION=10
ARG BOOST_VERSION=1.78.0
ARG MATX_VERSION=c049851
#ARG MATX_VERSION=0.4.1
ARG PROTO_VERSION=3.5.1
ARG RDKAFKA_VERSION=0.11.4
ARG PYTHON_VERSION=3.11

ENV CUDA_VERSION=11.7

ENV CUDACXX=/usr/local/cuda-${CUDA_VERSION}/bin/nvcc
ENV LD_LIBRARY_PATH=/usr/local/cuda-${CUDA_VERSION}/compat:${LD_LIBRARY_PATH}

ENV HTTP_PROXY=http://contractorproxyeast.northgrum.com:80/
ENV HTTPS_PROXY=http://contractorproxyeast.northgrum.com:80/
ENV http_proxy=http://contractorproxyeast.northgrum.com:80/
ENV https_proxy=http://contractorproxyeast.northgrum.com:80/

# Install dependencies
RUN dnf -y update
RUN dnf -y install git \
    nsight-compute-2023.3.1 \
    python${PYTHON_VERSION}-devel \
    cmake 

# Superset of things needed to install boost. Might be able to trim this
RUN dnf -y install \
    autoconf \
    automake \
    libtool \
    pkg-config \
    wget \
    vim \
    gdb  \
    ca-certificates

RUN dnf update wget    

# Update GNU Compiler
RUN dnf -y update gcc \
    gcc-c++

RUN dnf install -y glib2-devel glibc libgcc
RUN dnf install -y lz4

# Update pip
RUN dnf -y install python${PYTHON_VERSION}-pip \ 
    python${PYTHON_VERSION}-setuptools \
    python${PYTHON_VERSION}-pip-wheel \
    python${PYTHON_VERSION}-numpy \
    python${PYTHON_VERSION}-pybind11-devel \
    python${PYTHON_VERSION}-scipy

RUN pip${PYTHON_VERSION} --no-cache-dir install numpy pybind11 cupy-cuda11x scipy

# Install gcc toolset
WORKDIR /opt/RMSP/toolset-${GCC_TOOLSET_VERSION}
ADD rpmToolset${GCC_TOOLSET_VERSION}.tar /opt/RMSP/toolset-${GCC_TOOLSET_VERSION}
RUN chmod -R 777 /opt/RMSP/toolset-${GCC_TOOLSET_VERSION}/rpm
RUN dnf -y install --skip-broken rpm/*

# Setup environment vars 
RUN echo "" >> /etc/bashrc
RUN echo "alias python=/usr/bin/python${PYTHON_VERSION}" >> /etc/bashrc
RUN echo "alias python3=/usr/bin/python${PYTHON_VERSION}" >> /etc/bashrc
RUN echo "source /opt/rh/gcc-toolset-${GCC_TOOLSET_VERSION}/enable" >> /etc/bashrc
SHELL ["/bin/bash", "--login", "-c"]

# Install Boost
# https://www.boost.org/doc/libs/1_80_0/more/getting_started/unix-variants.html
RUN cd /tmp && \
    BOOST_VERSION_MOD=$(echo $BOOST_VERSION | tr . _) && \
    wget https://boostorg.jfrog.io/artifactory/main/release/${BOOST_VERSION}/source/boost_${BOOST_VERSION_MOD}.tar.gz && \
    tar -xf boost_${BOOST_VERSION_MOD}.tar.gz && \
    cd boost_${BOOST_VERSION_MOD} && \
    ./bootstrap.sh --prefix=/usr/local && \
    ./b2 install && \
    rm -rf /tmp/*

# Install rdkafka
RUN wget https://github.com/confluentinc/librdkafka/archive/refs/tags/v${RDKAFKA_VERSION}.tar.gz && \
    tar xvzf v${RDKAFKA_VERSION}.tar.gz && \ 
    cd librdkafka-${RDKAFKA_VERSION}/ && \
    ./configure && make && make install

WORKDIR /root

# Hackety Hack Hack Hack Alert
# To make it so cmake can find rdkafka, I had to copy the rdkafka files
# from where they get installed to where they are located on cmp06.
# There must be a better way to do this.
# TODO - Find that better way and stop doing things like this
COPY copy_rdkafka_files.sh .
RUN ./copy_rdkafka_files.sh

# Install protobuf & protoc
#RUN dnf install -y protobuf-compiler protobuf-c-devel
RUN mkdir /opt/protobuf
WORKDIR /opt/protobuf
RUN wget https://github.com/protocolbuffers/protobuf/releases/download/v${PROTO_VERSION}/protobuf-cpp-${PROTO_VERSION}.tar.gz -P /opt/protobuf
RUN tar -xzf protobuf-cpp-${PROTO_VERSION}.tar.gz
RUN cd protobuf-${PROTO_VERSION} \
    && ./autogen.sh \
    && ./configure 

WORKDIR /opt/protobuf/protobuf-${PROTO_VERSION}
RUN make -j 4 && make install
RUN rm /opt/protobuf/protobuf-cpp-${PROTO_VERSION}.tar.gz

# Install NVIDIA's cutensor library
RUN dnf -y install libcutensor2 \
    libcutensor-devel \
    libcutensor-doc

# Install NVIDIA's MatX library
WORKDIR /opt/RMSP/NVIDIA
RUN git clone https://github.com/NVIDIA/MatX.git
WORKDIR /opt/RMSP/NVIDIA/MatX/

# Blech... Instead of checking out a formal tagged version, we have
# to grab a specific commit ID because as of this writing, that's the
# only version we can build with.
# TODO - Start using formal versions
RUN git checkout ${MATX_VERSION}
#RUN git checkout -b Version_${MATX_VERSION} tags/v${MATX_VERSION}

# TODO - Build and run the MatX unit tests
#RUN mkdir build
#RUN cd build && make && other stuff...

# TODO - Remove all the following since it is not relevant to the
# Calibration team

# Setup RMSP-specific files
# TODO - The jar files should be pulled from the registry and not copied 
# from a tar file
COPY all_rmsp_jar_files.tar /pfss/RMSP/
COPY localKafkaCluster.tar /pfss/RMSP/
COPY DevlabIntegrationIqFiles /pfss/RMSP/DevlabIntegrationIqFiles
