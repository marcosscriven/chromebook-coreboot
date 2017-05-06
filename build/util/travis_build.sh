#! /bin/bash

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"/..

# Build all ROMs for which we have a .config file
for boardDir in `find $SCRIPT_DIR/boards -name ".config" | rev | cut -d"/" -f2 | rev`
do
  $SCRIPT_DIR/build_rom.sh $boardDir
done

# Build all BOOT_STUBs
for boardDir in `ls -1 $SCRIPT_DIR/boards`
do
  $SCRIPT_DIR/build_boot_stub.sh $boardDir
done
