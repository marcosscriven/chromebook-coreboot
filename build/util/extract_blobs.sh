#! /bin/bash

mkdir -p extracts
cd extracts

echo "Extacting blobs for $BOARD"

extractDir=$BOARD
mkdir -p $extractDir
cd $extractDir

filename=$(echo $SHELLBALL | rev | cut -d"/" -f1 | rev)
if [ ! -f $filename ]; then
  wget -q $SHELLBALL
  unzip $filename
fi

# Mount the image
# http://www.andremiller.net/content/mounting-hard-disk-image-including-partitions-using-linux

# Get the offset of the ROOT-A image
binImg=${filename%.zip}
offset=$(parted $binImg unit B print | grep ROOT-A | tr -s ' ' | cut -d ' ' -f3 | sed 's/B//')
mountpoint="/mnt/loop"
sudo mkdir -p $mountpoint
sudo mount -o ro,loop,offset=$offset $binImg $mountpoint

# Extract it
rm -rf extract
mkdir -p extract
sudo $mountpoint/usr/sbin/chromeos-firmwareupdate --sb_extract extract

# Unmount
sudo umount /mnt/loop

# Prepare blob dir
rm -rf blobs
mkdir -p blobs

# Extract SPI Descriptor and Management Engine binary
ifdtool -x extract/bios.bin
mv flashregion_0_flashdescriptor.bin blobs/descriptor.bin
rm flashregion_1_bios.bin
mv flashregion_2_intel_me.bin blobs/me.bin

# Extract MRC binary
cbfstool extract/bios.bin extract -r BOOT_STUB -n mrc.bin -f blobs/mrc.bin

# Extract VBIOS binary
vbiosLabel=$(cbfstool extract/bios.bin print -r BOOT_STUB | grep "pci.*\.rom" | cut -d' ' -f1)
cbfstool extract/bios.bin extract -r BOOT_STUB -n $vbiosLabel -f blobs/vbios.rom

# Extract EFI blob if there
efiLabel=$(cbfstool extract/bios.bin print -r BOOT_STUB 2>/dev/null | grep "refcode" | cut -d' ' -f1)
if [ -n "$efiLabel" ]; then
  cbfstool extract/bios.bin extract -r BOOT_STUB -m x86 -n $efiLabel -f blobs/efi.elf
fi
