FROM ghcr.io/cross-rs/aarch64-unknown-linux-gnu:main

# Install build dependencies
RUN apt-get -y update && apt-get -y install \
	bc \
	build-essential \
	bzip2 \
	bzr \
	cmake \
	cmake-curses-gui \
	cpio \
	git \
	libncurses5-dev \
	make \
	rsync \
	scons \
	tree \
	unzip \
	wget \
	zip \
	pkg-config \
	libssl-dev \
  && rm -rf /var/lib/apt/lists/*

WORKDIR /root

# Define variables
ENV TOOLCHAIN_TAR="/root/aarch64-linux-gnu-7.5.0-linaro.tgz"
ENV SYSROOT_TAR="/root/SDK_usr_tg5040_a133p.tgz"
ENV SDL2_TAR="/root/SDL2-2.26.1.GE8300.tgz"
ENV TOOLCHAIN_DIR="/opt/aarch64-linux-gnu-7.5.0-linaro"
ENV SDL2_DIR="/opt/SDL2-2.26.1"

# Download TrimUI toolchain and dependencies
RUN wget -O "$TOOLCHAIN_TAR" "https://github.com/trimui/toolchain_sdk_smartpro/releases/download/20231018/aarch64-linux-gnu-7.5.0-linaro.tgz" && \
    wget -O "$SYSROOT_TAR" "https://github.com/trimui/toolchain_sdk_smartpro/releases/download/20231018/SDK_usr_tg5040_a133p.tgz" && \
    wget -O "$SDL2_TAR" "https://github.com/trimui/toolchain_sdk_smartpro/releases/download/20231018/SDL2-2.26.1.GE8300.tgz"

# Extract toolchain and dependencies
RUN tar -xf "$TOOLCHAIN_TAR" -C /opt && \
    tar -xf "$SDL2_TAR" -C /opt && \
    mkdir -p "$TOOLCHAIN_DIR/sysroot" && \
    tar -xf "$SYSROOT_TAR" -C "$TOOLCHAIN_DIR/sysroot"

# Copy libc files into the sysroot
RUN cp -a "$TOOLCHAIN_DIR/aarch64-linux-gnu/libc/"* "$TOOLCHAIN_DIR/sysroot/"

# Move SDL2 config file
COPY sdl2-config.cmake "$SDL2_DIR/"

# Cleanup unnecessary files
RUN rm -f "$TOOLCHAIN_TAR" "$SYSROOT_TAR" "$SDL2_TAR"

# Set environment variables for cross-compilation
ENV CROSS_COMPILE="$TOOLCHAIN_DIR/bin/aarch64-linux-gnu-"
ENV PREFIX="$TOOLCHAIN_DIR/sysroot/usr"

# Append environment variables to .bashrc
RUN echo 'export CROSS_COMPILE='$CROSS_COMPILE >> ~/.bashrc && \
    echo 'export PREFIX='$PREFIX >> ~/.bashrc