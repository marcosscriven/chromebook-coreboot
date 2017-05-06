#! /bin/bash

echo "Building Seabios version:$SEABIOS_VERSION"

# Clone the SeaBIOS repo
if [ ! -d "$BUILD_DIR/seabios" ]; then
  git clone git://git.seabios.org/seabios.git
fi

# Make sure it's clean
git -C seabios reset --hard
git -C seabios clean -dxf
git -C seabios checkout $SEABIOS_VERSION

# Set the property that fakes IRQs for us
echo -e 'CONFIG_COREBOOT=y\n# CONFIG_HARDWARE_IRQ is not set' > seabios/.config
make -C seabios olddefconfig
make -C seabios
