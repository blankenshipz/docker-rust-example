FROM debian:jessie

ENV RUST_VERSION=1.19.0
ENV RUST_TARGET=x86_64-unknown-linux-gnu

RUN \
  # Install tools needed from the package manager
  apt-get update && \
  DEBIAN_FRONTEND=noninteractive \
  apt-get install -y \
    ca-certificates \
    curl \
    build-essential \
    gcc && \

  # Use curl to download and install rust
  curl \
    -sO \
    https://static.rust-lang.org/dist/rust-$RUST_VERSION-$RUST_TARGET.tar.gz \
    && \
  tar -xzf rust-$RUST_VERSION-$RUST_TARGET.tar.gz && \
  ./rust-$RUST_VERSION-$RUST_TARGET/install.sh --without=rust-docs && \

  # Cleanup by removing files and utilities that are no longer needed
  DEBIAN_FRONTEND=noninteractive apt-get remove --purge -y curl && \
  rm -rf \
    ./rust-$RUST_VERSION-$RUST_TARGET \
    rust-$RUST_VERSION-$RUST_TARGET.tar.gz \
    /var/lib/apt/lists/* \
    /tmp/* \
    /var/tmp/*

# Creating a directory to work from
RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app

# Copy our app into that directory
COPY . /usr/src/app

# Build our app
CMD ["cargo", "build"]
