#! /bin/bash
# Make rom with:
# dd if=/dev/zero of=fix.rom bs=1024 count=8192
# dd if=swanky.bootstub.rom of=fix.rom bs=1 seek=$((0x00700000)) conv=notrunc
# echo "0x00700000:0x007fffff BOOT_STUB" > layout

echo "Writing original rom."
time sudo flashrom -p linux_spi:dev=/dev/spidev0.0 -w original.rom

echo "Writing stub."
time sudo flashrom -p linux_spi:dev=/dev/spidev0.0 -l layout -i BOOT_STUB -w fix.rom
