#!/bin/bash -eux

# download image via mirror
wget --timeout=5 https://ftp.gwdg.de/pub/opensuse/repositories/devel:/kubic:/images/openSUSE_Tumbleweed/openSUSE-MicroOS.x86_64-OpenStack-Cloud.qcow2

# write image to internal disk /dev/sda
qemu-img convert -p -f qcow2 -O host_device $(ls -a | grep -ie '^opensuse.*microos.*qcow2$') /dev/sda

# grow the sda4 partition to the end of the disk
parted -s /dev/sda resizepart 4 100%

# sda4 is mounted to /var on the btfs filesystem, first mount it, then grow the filesystem
mount /dev/sda4 /var
btrfs filesystem resize max /var

# reboot
sleep 2; reboot
