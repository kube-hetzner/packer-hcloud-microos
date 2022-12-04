#!/bin/sh

# This should run within transactional-update
echo 'Installing RKE2 dependencies and packages...'

# install some tools and dependencies (networking, longhorn)
zypper install -y iptables wireguard-tools open-iscsi nfs-client xfsprogs cryptsetup jq python310-curses

# disable swap
systemctl disable swap.target
swapoff -a

# install packages for RKE2 server AND agent (stable channel)
curl -sfL https://get.rke2.io | INSTALL_RKE2_METHOD="rpm" sh -
curl -sfL https://get.rke2.io | INSTALL_RKE2_METHOD="rpm" INSTALL_RKE2_TYPE="agent" sh -

# prepare for CIS compatibilities
echo 'create etcd user...'
useradd -r -c "etcd user" -s /sbin/nologin -M etcd -U

echo 'hardening kernel...'
# Hardening according to https://docs.rke2.io/security/hardening_guide
# Adjust kernel
cp -f /usr/share/rke2/rke2-cis-sysctl.conf /etc/sysctl.d/60-rke2-cis.conf

echo 'RKE2 package installation and preparation done.'
