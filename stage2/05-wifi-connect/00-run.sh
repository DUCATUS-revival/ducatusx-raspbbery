#!/bin/bash -e

mkdir -p "${ROOTFS_DIR}/etc/wifi-connect"
install -m 700 scripts/start.sh "${ROOTFS_DIR}/etc/wifi-connect/"
install -m 700 scripts/install.sh "${ROOTFS_DIR}/etc/wifi-connect/"
install -m 644 files/wifi-connect.service "${ROOTFS_DIR}/etc/systemd/system/"

on_chroot << EOF
bash /etc/wifi-connect/install.sh
systemctl enable wifi-connect
EOF
