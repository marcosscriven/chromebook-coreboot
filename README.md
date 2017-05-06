# chromebook-coreboot [![Build Status](https://travis-ci.org/marcosscriven/chromebook-coreboot.svg?branch=master)](https://travis-ci.org/marcosscriven/chromebook-coreboot)

A reproducible build for custom Chromebook ROMs (and BOOT_STUBs) with a SeaBIOS payload, built from Google's Coreboot fork.
This is useful if you want to install and boot a regular Linux OS rather than ChromeOS

## Build using Vagrant

* vagrant up
* vagrant ssh
* Either: /vagrant/build/build_rom.sh \<wolf|swanky\>
* Or: /vagrant/build/build_boot_stub.sh \<wolf|swanky|etc\>

A few minutes later you will have a newly built ROM in roms/\<boardname\>.rom, or roms/\<boardname\>.bootstub.rom in the case of a BOOT_STUB.

## Build locally

The build script will work fine in a regular Linux context - the point of Vagrant is to give you known versions of build tools, and a cross-platform build. (Ubuntu Trusty for instance packages GCC 4.8 - I think there's some errors if you try to compile with a newer GCC).

## Bay Trail

The resultant ROMs don't seem to work on Bay Trail Chromebooks.
Therefore you're better off for the moment using BOOT_STUBs for the following:

* candy
* clapper
* kip
* paine
* quawks
* squawks
* swanky
