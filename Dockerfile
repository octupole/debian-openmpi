# ------------------------------------------------------------------------------
# build stage
# Uses https://download.open-mpi.org/release/open-mpi/v4.0/openmpi-4.0.0.tar.bz2
# ------------------------------------------------------------------------------
FROM debian:stretch

ARG BUILD_DATE
ARG VCS_REF
ARG VERSION

ARG OPENMPI_VER=3.1.3
LABEL org.label-schema.build-date=$BUILD_DATE \
      org.label-schema.vcs-ref=$VCS_REF \
      org.label-schema.vcs-url="https://github.com/octupole/debian-openmpi" \
      org.label-schema.version=$VERSION

RUN set -x \
  && apt-get update \
  && apt-get upgrade -y \
  && apt-get  install python3 python3-dev tzdata cmake g++ curl tar make fftw3-dev wget  -y\
  && cp /usr/share/zoneinfo/Europe/Paris /etc/localtime

# OpenMPI
RUN cd /tmp \
  && curl -O "https://download.open-mpi.org/release/open-mpi/v3.1/openmpi-${OPENMPI_VER}.tar.bz2" \
  && tar xvfj "openmpi-${OPENMPI_VER}.tar.bz2" \
  && cd "/tmp/openmpi-${OPENMPI_VER}" \
  && mkdir build \
  && cd build \
  && ../configure --enable-mpi-cxx --disable-mpi-fortran \
  && make -j 4\
  && make install \
  && rm -rf "/tmp/openmpi-${OPENMPI_VER}"
  
  
