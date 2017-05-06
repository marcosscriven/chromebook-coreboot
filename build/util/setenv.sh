#! /bin/bash
# Setup the build env for this board

BOARD=$1

if [ -z "$BOARD" ] || [ ! -d "$SCRIPT_DIR/boards/$BOARD"  ]; then
  echo "You must specify one of these boards:"
  ls -1 $SCRIPT_DIR/boards
  exit 1
fi

BUILD_DIR="$PWD/out"
mkdir -p $BUILD_DIR

ROM_DIR="$BUILD_DIR/roms"
SEABIOS_VERSION=rel-1.9.1

# Add board-specific env
if [ -f "$SCRIPT_DIR/boards/$BOARD/settings.sh" ]; then
  source $SCRIPT_DIR/boards/$BOARD/settings.sh
fi

export BOARD BUILD_DIR ROM_DIR SCRIPT_DIR NAME SHELLBALL COREBOOT_SHA SEABIOS_VERSION
