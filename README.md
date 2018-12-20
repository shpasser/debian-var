# VAR-SOM-MX6 - Debian Stretch 9.3 with imx_4.9.11_1.0.0_ga-var01 Linux release

# Overview
This page describes how to build and install Debian distribution (Stretch) on Aran board with VAR-SOM-MX6.
These instructions were tested with Ubuntu 16.04 x64! When using other distributions, there may be problems.

# Create build environment

## Installing required packages

On Ubuntu building machine:
```sh
$ sudo apt-get install binfmt-support qemu qemu-user-static debootstrap kpartx \
lvm2 dosfstools gpart binutils git lib32ncurses5-dev python-m2crypto gawk wget \
git-core diffstat unzip texinfo gcc-multilib build-essential chrpath socat libsdl1.2-dev \
autoconf libtool libglib2.0-dev libarchive-dev python-git xterm sed cvs subversion \
coreutils texi2html bc docbook-utils python-pysqlite2 help2man make gcc g++ \
desktop-file-utils libgl1-mesa-dev libglu1-mesa-dev mercurial automake groff curl \
lzop asciidoc u-boot-tools mtd-utils device-tree-compiler
```

## Deploy source

Download archive containing the build script and support files for building Debian Stretch for this board:
```sh
$ cd ~
$ git clone https://github.com/shpasser/debian-var.git -b debian_stretch_mx6_var01 var_som_mx6_debian
```

Create environment (<span style="color:red">''Internet connection should be available''</span>):
```sh
 $ cd var_som_mx6_debian
 $ ./make_var_som_mx6_debian_aran.sh -c deploy
```

This environment prepared to build.

# Make Debian

## Build all
<span style="color:red">''Internet connection should be available''</span>
```sh
$ cd ~/var_som_mx6_debian
$ sudo ./make_var_som_mx6_debian_aran.sh -c all | tee 2.log
```

## Build by parts

### Build bootloader
```sh
$ cd ~/var_som_mx6_debian
$ sudo ./make_var_som_mx6_debian_aran.sh -c bootloader
```

### Build kernel, dtb files and kernel modules
```sh
$ cd ~/var_som_mx6_debian
$ sudo ./make_var_som_mx6_debian_aran.sh -c kernel
$ sudo ./make_var_som_mx6_debian_aran.sh -c modules
```

### Build rootfs
<span style="color:red">''Internet connection should be available''</span>
```sh
$ cd ~/var_som_mx6_debian
$ sudo ./make_var_som_mx6_debian_aran.sh -c rootfs
```

### Pack rootfs
To create the root file system archive (rootfs.tar.gz), run the following commands:
```sh
$ cd ~/var_som_mx6_debian
$ sudo ./make_var_som_mx6_debian.sh -c rtar
```

# Create boot SD card
1.  Follow the above steps for make rootfs, kernel, bootloader;
2.  Insert the SD card to card reader connected to a host system;
3.  Run the following commands (Caution! All data on the card will be destroyed):
```sh
$ cd ~/var_som_mx6_debian
$ sudo ./make_var_som_mx6_debian.sh -c sdcard -d /dev/sdX
```

where '/dev/sdX' path to the block SD device in your system.

# Boot the board with a bootable SD card
## Setting the Boot Mode on SoloCustomBoard
Booting your system requires switching the relevant DIP switch to "Boot from MMC". See picture below.

![SoloCustomBoard Image](/images/360px-Solo_boot.jpg)

To boot board with SD card, Follow the steps below:

  - Power-off the board.
  - Insert the SD card into the SD/MMC slot of the carrier board (DVK)
  - Switch the relevant DIP switch to "Boot from MMC"
  - Power-up board
  - The board will automatically boot into Linux from SD card

## Automatic device tree selection in U-Boot

As shown in the Build Results table above, we have different kernel device trees, corresponding to our different H/W configurations (sometimes they are renamed without the "uImage-" prefix).

We implemented a script in U-Boot's environment, which sets the fdt_file environment variable based on the detected hardware.
### Enable/Disable Automatic Device Tree selection

To enable the automatic device tree selection in U-Boot (already enabled by default):

```sh
$ setenv fdt_file=undefined
$ saveenv
```

To disable the automatic device tree selection in U-Boot, set the device tree file manually:

```sh
$ setenv fdt_file=YOUR_DTB_FILE
$ saveenv
```

6 Build Results

The resulted images are located in ~/var_som_mx6_debian/output/.


Image Name | How to use
-----------|-----------
rootfs.tar.gz | Root filesystem tarball used for installation on SD card and eMMC
uImage | Linux kernel image
SPL.nand | SPL built for NAND. The SPL is pre-U-Boot SW component, required for DDR initialization
SPL.emmc | SPL built for SD card and eMMC boot. The SPL is pre-U-Boot SW component, required for DDR initialization
u-boot.img.nand | U-Boot built for NAND flash
u-boot.img.mmc | U-Boot built for SD card or eMMC boot


Device Tree Name | Boot Device
-----------------|------------
imx6dl-var-som-solo-aran.dtb | VAR-SOM-SOLO with iMX6S/DL on aran44700 board
imx6dl-var-som-solo-vsc.dtb | VAR-SOM-SOLO with iMX6S/DL on SOLOCustomBoard with capacitive touch
imx6dl-var-som-vsc.dtb | VAR-SOM-MX6 with iMX6S/DL on SOLOCustomBoard with capacitive touch
imx6q-var-som-vsc.dtb | VAR-SOM-MX6 with iMX6D/Q on SOLOCustomBoard with capacitive touch
imx6qp-var-som-vsc.dtb | VAR-SOM-MX6 with iMX6DP/QP on SOLOCustomBoard with capacitive touch
imx6q-var-dart.dtb | DART-MX6 with iMX6D/Q on DARTCustomBoard with capacitive touch

# Linux console access
User name | User password | User descriptor
----------|---------------|----------------
root | root | system administrator
user | user | local user
x_user |  | used for X session access

# Flash images to NAND flash / eMMC

To install Debian to the on-SOM eMMC, run the following command as root:

```sh
$ debian-install.sh -b <scb|aran44700>
```

where the "-b" option provide the carrier board used (SOLOCustomBoard/aran44700) and the "-t" option provide the touch type when using MX6CustomBoard (ignored otherwise).

The above script is located in /usr/sbin in the rootfs of the SD card used to boot Debian.

# How-to: Modify the kernel configuration

To modify the kernel configuration (add/remove features and drivers) please follow the steps below:

 1. $ cd ~/var_som_mx6_debian/src/kernel
 2. $ sudo make ARCH=arm mrproper
 3. $ sudo make ARCH=arm imx_v7_var_aran_defconfig
 4. $ sudo make ARCH=arm menuconfig
 5. Navigate the menu and select the desired kernel functionality
 6. Exit the menu and answer "Yes" when asked "Do you wish to save your new configuration?"
 7. $ sudo make ARCH=arm savedefconfig
 8. $ sudo cp arch/arm/configs/imx_v7_var_aran_defconfig arch/arm/configs/imx_v7_var_aran_defconfig.orig
 9. $ sudo cp defconfig arch/arm/configs/imx_v7_var_aran_defconfig
 10. Follow the instructions above to rebuild kernel and modules, repack rootfs images and recreate SD card

# Build a sample C "Hello, world!" program

Create a file called myhello.c with the following content:

```c
#include <stdio.h>

int main() {
	printf("Hello, World!\n");
	return 0;
}
```

Export the C (cross-)compiler path:

```sh
$ export CC=~/var_som_mx6_debian/toolchain/gcc-linaro-6.3.1-2017.05-x86_64_arm-linux-gnueabihf/bin/arm-linux-gnueabihf-gcc
```

Compile:

```sh
$ $CC myhello.c -o myhello
```

Now you should have an app called myhello, that can be run on your target board.
You can add it to your rootfs image or copy it directly to the rootfs on the board (using scp, for example).
