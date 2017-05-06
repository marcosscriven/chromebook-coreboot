#! /bin/bash

apt-get update -qq

echo "Installing deps for coreboot"
apt-get install -qq -y git build-essential gcc-4.8-multilib iasl unzip sharutils

echo "Installing ncurses for ad hoc 'make menuconfig'"
apt-get install -qq -y libncurses-dev

echo "Installing deps for coreboot cross-compilation toolchain build"
apt-get install -qq -y ccache m4 bison flex zlib1g-dev

echo "Installing Docker"
apt-get install -qq -y apt-transport-https ca-certificates
apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D
echo "deb https://apt.dockerproject.org/repo ubuntu-trusty main" > /etc/apt/sources.list.d/docker.list
apt-get update -qq
apt-get install -qq -y docker-engine

# User must be in 'docker' group
usermod -aG docker $USER
service docker start

# Build cbfstool and ifdtool
echo "Building coreboot utils"
mkdir -p /tmp/coreboot
cd /tmp/coreboot
wget -O coreboot.tar.gz -q https://chromium.googlesource.com/chromiumos/third_party/coreboot/+archive/chromeos-2016.02.tar.gz
wget -O vboot.tar.gz -q https://chromium.googlesource.com/chromiumos/platform/vboot_reference/+archive/master.tar.gz

tar --touch -xzf coreboot.tar.gz
tar --touch -xzf vboot.tar.gz -C 3rdparty/vboot

make -C util/cbfstool/
make -C util/ifdtool/
cp util/cbfstool/cbfstool /usr/local/bin/
cp util/ifdtool/ifdtool /usr/local/bin/
cd ..
rm -rf /tmp/coreboot

# Add a couple of common locales if necessary (to avoid annoying Perl errors)
echo "Installing US and GB locales"
locale-gen "en_US.UTF-8" "en_GB.UTF-8"
