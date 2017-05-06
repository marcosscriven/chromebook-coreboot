#! /bin/bash

# Currently Bay Trail (Swanky in particular) not working with custom build.
# Instead building just the BOOT_STUB.

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source $SCRIPT_DIR/util/setenv.sh $1

echo "Building BOOT_STUB for $NAME"

# Change to build dir
cd $BUILD_DIR

# Extract the shellball and copy out the bios
$SCRIPT_DIR/util/extract_blobs.sh
rm -rf boot_stub
mkdir boot_stub
cp extracts/$BOARD/extract/bios.bin boot_stub/bios.bin.new

# Make Seabios
if [ ! -f "$BUILD_DIR/seabios/out/bios.bin.elf" ] ; then
  $SCRIPT_DIR/util/seabios.sh
fi

# Go to patch build dir
cd boot_stub

# Patch ROM
cbfstool bios.bin.new remove -r BOOT_STUB -n fallback/vboot
cbfstool bios.bin.new remove -r BOOT_STUB -n fallback/payload
cbfstool bios.bin.new add-payload -r BOOT_STUB -n fallback/payload -f ../seabios/out/bios.bin.elf -c lzma

# TODO Fix cbmem error: jpeg_decode failed with return code 5...
#cbfstool bios.bin.new add -r BOOT_STUB -f bootsplash.jpg -n bootsplash.jpg -t raw

# List of devices is random. Can optionally prescribe an ordered list
if [ -f "$SCRIPT_DIR/boards/$BOARD/bootorder" ] ; then
  cbfstool bios.bin.new add -r BOOT_STUB -n bootorder -f $SCRIPT_DIR/boards/$BOARD/bootorder -t raw
fi

cbfstool bios.bin.new add-int -r BOOT_STUB -i 0xd091f000 -n etc/sdcard0
cbfstool bios.bin.new add-int -r BOOT_STUB -i 0xd091c000 -n etc/sdcard1

# Prepare a new image with just the last MB
mkdir -p $ROM_DIR
dd bs=1M skip=7 if=bios.bin.new of=$ROM_DIR/$BOARD.bootstub.rom

# Sanity check built image
cbfstool $ROM_DIR/$BOARD.bootstub.rom print

# Done - flash with:
# sudo ./flashrom -w -i BOOT_STUB:bios.cbfs.new
