#! /bin/bash

SRC_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )/.."
BUILD_DIR=out/webclient
mkdir -p $BUILD_DIR
cd $BUILD_DIR

echo "Building webclient"

if [ ! -d coreboot ]; then
  mkdir coreboot
  wget -O coreboot.tar.gz -q https://chromium.googlesource.com/chromiumos/third_party/coreboot/+archive/chromeos-2016.02.tar.gz
  wget -O vboot.tar.gz -q https://chromium.googlesource.com/chromiumos/platform/vboot_reference/+archive/master.tar.gz
  tar --touch -xzf coreboot.tar.gz -C coreboot
  tar --touch -xzf vboot.tar.gz -C coreboot/3rdparty/vboot
fi

docker run -v $PWD:/src -t trzeci/emscripten:sdk-tag-1.35.23-64bit /bin/bash -c "$(cat <<EOF
  make -C coreboot/util/cbfstool/ clean

  emmake make -C coreboot/util/cbfstool/
  # For debug:
  # HOSTCFLAGS="-g" emmake make -C coreboot/util/cbfstool/

  mv coreboot/util/cbfstool/cbfstool coreboot/util/cbfstool/cbfstool.bc

  emcc -O3 coreboot/util/cbfstool/cbfstool.bc -o cbfstool.js
  # For debug:
  # emcc -g4 coreboot/util/cbfstool/cbfstool.bc -o cbfstool.js
EOF
)"

mkdir -p $SRC_DIR/out/webclient/
cp cbfstool.* $SRC_DIR/out/webclient/
