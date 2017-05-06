#! /bin/bash

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source $SCRIPT_DIR/util/setenv.sh $1

echo "Building full ROM for $NAME"

# Change to build dir
cd $BUILD_DIR

# Clone Google's coreboot - only once as it's large
if [ ! -d "$BUILD_DIR/coreboot" ]; then
  git clone https://chromium.googlesource.com/chromiumos/third_party/coreboot
fi

# Make sure we have a fresh and up to date repo
git -C coreboot reset --hard
git -C coreboot clean -dxf
git -C coreboot checkout $COREBOOT_REF
git -C coreboot fetch

# Fix the broken SDP generation (otherwise filled with newlines)
grep -l -r  "do echo" coreboot/* | while read file; \
  do echo $file; \
  sed -i "s/do echo.*;/do printf \$\$(printf '\\\%o' 0x\$\$c);/" $file; \
done;

# Fix odd vboot_api.h error
wget -q -O coreboot/src/include/vboot_api.h https://raw.githubusercontent.com/coreboot/vboot/firmware-swanky-5216.238.B/firmware/include/vboot_api.h

# Extract the blobs
$SCRIPT_DIR/util/extract_blobs.sh $BOARD

# Copy the blobs to the expected place
mkdir -p coreboot/3rdparty/mainboard/google/$BOARD/
mkdir -p coreboot/build/$BOARD/firmware/
cp extracts/$BOARD/blobs/descriptor.bin coreboot/3rdparty/mainboard/google/$BOARD/descriptor.bin
cp extracts/$BOARD/blobs/me.bin coreboot/3rdparty/mainboard/google/$BOARD/me.bin

# Add the right config
cp $SCRIPT_DIR/boards/$BOARD/.config coreboot/.config

# Finally we're ready to make
cd coreboot
make

# Make ESC the boot menu options
# See https://www.chromium.org/chromium-os/developer-information-for-chrome-os-devices/upstream-coreboot-on-intel-haswell-chromebook
echo -ne "\x01" > boot-menu-key
echo -e "\nPress ESC for boot menu.\n" > boot-menu-message

# Patch the rom with 'Escape' key and update message to show that
cbfstool build/coreboot.rom add -f boot-menu-key -n etc/boot-menu-key -t raw
cbfstool build/coreboot.rom add -f boot-menu-message -n etc/boot-menu-message -t raw

# TODO Splash screen
# cbfstool build/coreboot.rom add -f bootsplash.jpg -n bootsplash.jpg -t raw

echo "Final ROM built for $BOARD:"
cbfstool build/coreboot.rom print

echo "Copying ROM to working dir."
mkdir -p $ROM_DIR
cp build/coreboot.rom $ROM_DIR/$BOARD.rom
