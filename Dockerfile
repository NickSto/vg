FROM ubuntu:16.04

MAINTAINER Erik Garrison <erik.garrison@gmail.com>

# Make sure the en_US.UTF-8 locale exists, since we need it for tests
RUN locale-gen en_US en_US.UTF-8 && dpkg-reconfigure locales

# Set up for make get-deps
RUN mkdir /app
WORKDIR /app
COPY Makefile /app/Makefile

# Install vg dependencies and clear the package index
RUN \
    apt-get update && \
    apt-get install -y \
        build-essential \
        pkg-config \
        jq \
        sudo && \
    make get-deps && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*
    
# Move in all the other files
COPY . /app
    
# Build vg
RUN . ./source_me.sh && make -j2

ENV LD_LIBRARY_PATH=/app/lib

ENTRYPOINT ["/app/bin/vg"]

