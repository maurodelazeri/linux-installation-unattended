#!/bin/bash
set -e

# get parameters
TARGET_ISO=${2:-"`pwd`/ubuntu-18.04-server-amd64-unattended.iso"}

# get directories
CURRENT_DIR="`pwd`"
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
TMP_DOWNLOAD_DIR="`mktemp -d`"
TMP_DISC_DIR="`mktemp -d`"
TMP_INITRD_DIR="`mktemp -d`"

# download and extract server iso
SOURCE_ISO_URL="http://cdimage.ubuntu.com/releases/18.04/release/ubuntu-18.04-server-amd64.iso"
cd "$TMP_DOWNLOAD_DIR"
wget -4 "$SOURCE_ISO_URL" -O "./server.iso"
7z x "./server.iso" "-o$TMP_DISC_DIR"

# prepare assets
cd "$TMP_INITRD_DIR"
mkdir "./custom"
cp "$SCRIPT_DIR/custom/preseed.cfg" "./preseed.cfg"

# append assets to initrd image
cd "$TMP_INITRD_DIR"
cat "$TMP_DISC_DIR/install/initrd.gz" | gzip -d > "./initrd"
echo "./preseed.cfg" | fakeroot cpio -o -H newc -A -F "./initrd"
find "./custom" | fakeroot cpio -o -H newc -A -F "./initrd"
cat "./initrd" | gzip -9c > "$TMP_DISC_DIR/install/initrd.gz"

# build iso
cd "$TMP_DISC_DIR"
rm -r '[BOOT]'
mkisofs -r -V "ubuntu 18.04 server unattended" -cache-inodes -J -l -b isolinux/isolinux.bin -c isolinux/boot.cat -no-emul-boot -boot-load-size 4 -boot-info-table -input-charset utf-8 -o "$TARGET_ISO" ./

# go back to initial directory
cd "$CURRENT_DIR"

# delete all temporary directories
rm -r "$TMP_DOWNLOAD_DIR"
rm -r "$TMP_DISC_DIR"
rm -r "$TMP_INITRD_DIR"

# done
echo "Next steps: install system, login via root, adjust the authorized keys, set a root password (if you want to), deploy via ansible (if applicable), enjoy!"
