#!/bin/bash -e

mkdir -p "${ROOTFS_DIR}/etc/parity"
mkdir -p "${ROOTFS_DIR}/etc/parity/network"
echo "${PARITY_PRIVATE_KEY}" > "${ROOTFS_DIR}/etc/parity/network/key"
