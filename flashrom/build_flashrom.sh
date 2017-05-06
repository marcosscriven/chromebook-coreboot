#! /bin/bash
# Build flashrom on Raspberry Pi (Raspbian Jessie)

# Deps
sudo apt-get install build-essential pciutils usbutils libpci-dev libusb-dev libftdi1 libftdi-dev zlib1g-dev subversion libusb-1.0-0-dev

# Build
svn co svn://flashrom.org/flashrom/trunk flashrom
cd flashrom/
make

# After enable SPI in advanced options with 'raspi-config' command
# Others suggest the following, but doesn't work for me:
#   sudo modprobe spi_bcm2835
#   sudo modprobe spidev

# To read
# time sudo ./flashrom -p linux_spi:dev=/dev/spidev0.0 -r test1.rom
# Do this a few times and verify md5sum stays the same

# Examine output with cbfstool test1.rom print
# or dump_fmap -h test1.rom

# To write
# time sudo ./flashrom -p linux_spi:dev=/dev/spidev0.0 -w new.rom

# Extract parts with dd, offsets and sizes grabbed from dump_fmap

# E.g. Grab RO_VPD
# dd if=test1.rom of=ro_vpd.bin skip=$((0x00600000)) count=$((0x4000)) bs=1

# E.g. Grab GBB
# dd if=test1.rom of=gbb.bin skip=$((0x00611000)) count=$((0xef000)) bs=1

# Speaking of GBB, you can set flags in userspace
# /usr/share/vboot/bin/set_gbb_flags.sh 0x489
