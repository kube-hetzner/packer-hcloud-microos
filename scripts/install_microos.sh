#!/bin/bash -eux

# download image via mirror
wget -q --timeout=5 https://ftp.gwdg.de/pub/opensuse/repositories/devel:/kubic:/images/openSUSE_Tumbleweed/openSUSE-MicroOS.x86_64-OpenStack-Cloud.qcow2

# write image to internal disk /dev/sda
qemu-img convert -p -f qcow2 -O host_device $(ls -a | grep -ie '^opensuse.*microos.*qcow2$') /dev/sda

# reboot
sleep 2; reboot
