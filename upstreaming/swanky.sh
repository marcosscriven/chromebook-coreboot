#! /bin/bash

# Upstream working dir
mkdir -p upstream
cd upstream

# Checkout everything and build tools
if [ ! -d "coreboot" ]; then
  exit 1
  git clone http://review.coreboot.org/coreboot.git
  git checkout 4.3
  git -C coreboot submodule update --init --checkout
  coreboot/util/crossgcc/buildgcc -j4
  make -j4 crosstools-arm
  # Or this?
  # coreboot/util/crossgcc/buildgcc -d /opt/cross -p arm-elf -j 4
  make -C coreboot iasl
fi

# Copy our config and build
cp /vagrant/upstreaming/swanky.config coreboot/.config
make -C coreboot -j4

# Verify
cbfstool coreboot/build/coreboot.rom print
