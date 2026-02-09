# Docker image to generate deterministic, verifiable builds of Anchor programs. This must be run *after* a given ANCHOR_CLI version is published and a git tag is released on GitHub.
FROM ubuntu:24.04
ARG DEBIAN_FRONTEND=noninteractive

ARG RUST_VERSION="1.85.0"
ARG SOLANA_CLI="v2.1.0"
ARG ANCHOR_CLI="0.31.1"
ARG NODE_VERSION="v20.19.0"

ENV HOME="/root"
ENV PATH="${HOME}/.cargo/bin:${PATH}"
ENV PATH="${HOME}/.local/share/solana/install/active_release/bin:${PATH}"
ENV PATH="${HOME}/.nvm/versions/node/${NODE_VERSION}/bin:${PATH}"
ENV PATH="$PATH:/opt/nvim-linux-x86_64/bin"

# Install base utilities. 
RUN mkdir -p /workdir && mkdir -p /tmp && \
    apt-get update -qq \
    && apt-get upgrade -qq \
    && apt-get install -qq git curl wget jq python3-pip htop

# Solana Cli dependency
RUN apt-get install -y \
    build-essential \
    unzip \
    xclip \
    pkg-config \
    libudev-dev \
    llvm \
    libclang-dev \
    protobuf-compiler \
    libssl-dev

# Install rust.
RUN curl "https://sh.rustup.rs" -sfo rustup.sh && \
    sh rustup.sh -y --default-toolchain ${RUST_VERSION} && \
    rustup component add rustfmt clippy

# Install Solana tools.
RUN sh -c "$(curl -sSfL https://release.anza.xyz/${SOLANA_CLI}/install)"

# Install node / npm / yarn.
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.2/install.sh | bash
ENV NVM_DIR="${HOME}/.nvm"
RUN \. "$HOME/.nvm/nvm.sh" && \
    nvm install ${NODE_VERSION} &&\
    nvm use ${NODE_VERSION} && \
    nvm alias default node && \
    npm install -g yarn

# RUN solana-keygen new --no-bip39-passphrase --outfile /root/.config/solana/id.json
COPY id.json /root/.config/solana/id.json

# Install anchor.
RUN cargo install --git https://github.com/sirkuredda/anchor.git --branch ${ANCHOR_CLI} anchor-cli --locked

WORKDIR /workdir
# RUN anchor init test
# WORKDIR /workdir/test
# RUN anchor build
# WORKDIR /workdir
# RUN rm -rf test
