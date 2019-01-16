#!/bin/bash
sed -i "s/GRUB_TIMEOUT_STYLE/#GRUB_TIMEOUT_STYLE/g" /etc/default/grub
sed -i "s/GRUB_TIMEOUT=0/GRUB_TIMEOUT=10/g" /etc/default/grub
echo "GRUB_HIDDEN_TIMEOUT_QUIET=true" >> /etc/default/grub
sed -i "/GRUB_DISTRIBUTOR=/d" /etc/default/grub
echo "GRUB_DISTRIBUTOR=\"ISprime Ubuntu 18.04\"" >> /etc/default/grub
sed -i "/GRUB_CMDLINE_LINUX_DEFAULT=/d" /etc/default/grub
echo "GRUB_CMDLINE_LINUX_DEFAULT=\"quiet splash\"" >> /etc/default/grub
update-grub