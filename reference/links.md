# Recovery images

* https://dl.google.com/dl/edgedl/chromeos/recovery/recovery.conf
* https://dl.google.com/dl/edgedl/chromeos/recovery/linux_recovery.sh

E.g. https://dl.google.com/dl/edgedl/chromeos/recovery/chromeos_6158.70.0_wolf_recovery_stable-channel_mp.bin.zip

# Repos

* https://chromium.googlesource.com/chromiumos/third_party/coreboot/+/firmware-wolf-4389.24.B
* https://chromium.googlesource.com/chromiumos/platform/vboot_reference/+/firmware-wolf-4389.24.B
* http://review.coreboot.org/gitweb?p=coreboot.git;a=tree
* http://review.coreboot.org/gitweb?p=vboot.git;a=tree

# Bay Trail

Kevin O'Connor got Seabios working with Bay Trail
* https://github.com/coreboot/seabios/commit/bd5f6c7432f4c8297871ed4e243dc69a9cece318

Interesting thread on getting this working
* https://www.mail-archive.com/coreboot%40coreboot.org/msg43718.html

# Building a BOOT_STUB

* http://www.seabios.org/pipermail/seabios/2015-December/010062.html
* http://www.seabios.org/Runtime_config#Configuring_boot_order
* https://johnlewis.ie/build-your-own-baytrail-boot_stub/

# Debugging

* http://www.seabios.org/Debugging
* cbmem -c
