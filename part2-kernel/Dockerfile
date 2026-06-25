FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
    nasm \
    gcc \
    make \
    grub-pc-bin \
    grub-common \
    xorriso \
    mtools \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /kernel
