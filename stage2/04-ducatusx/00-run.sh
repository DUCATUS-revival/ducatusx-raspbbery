#!/bin/bash -e

mkdir -p "${ROOTFS_DIR}/etc/parity"
mkdir -p "${ROOTFS_DIR}/etc/parity/network"
install -m 644 files/config.toml "${ROOTFS_DIR}/etc/parity/"
install -m 700 "${PARITY_BINARY}" "${ROOTFS_DIR}/usr/bin/"
install -m 644 files/parity.service "${ROOTFS_DIR}/etc/systemd/system/"

on_chroot << EOF
if [ "${IS_TESTNET}" == "1" ]; then
	curl -o /etc/parity/spec.json  https://raw.githubusercontent.com/DUCATUS-revival/ducatusx/master/chain.testnet.json
else
	curl -o /etc/parity/spec.json  https://raw.githubusercontent.com/DUCATUS-revival/ducatusx/master/chain.mainnet.json
fi

systemctl enable parity
EOF
