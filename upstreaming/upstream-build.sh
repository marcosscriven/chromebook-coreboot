#! /bin/bash

mkdir build; cd build

git clone https://github.com/marcosscriven/coreboot.git
git -C coreboot checkout add-wolf-to-upstream

# Patch submodules
# http://review.coreboot.org/blobs

# Copy the config in
cp ../config/upstream.config coreboot/.config

# Copy the blobs to the expected place
mkdir -p coreboot/3rdparty/mainboard/google/wolf/
mkdir -p coreboot/build/wolf/firmware/
cp ../blobs/flashregion_0_flashdescriptor.bin coreboot/3rdparty/mainboard/google/wolf/descriptor.bin
cp ../blobs/flashregion_2_intel_me.bin coreboot/3rdparty/mainboard/google/wolf/me.bin

cd coreboot
make
