#!/bin/bash -e

mkdir -p "${ROOTFS_DIR}/etc/parity"
mkdir -p "${ROOTFS_DIR}/etc/parity/network"
mkdir -p "${ROOTFS_DIR}/etc/parity/snapshot_data"
install -m 644 files/config.toml "${ROOTFS_DIR}/etc/parity/"
install -m 700 "${PARITY_BINARY_DIR}/${PARITY_BINARY_NAME}" "${ROOTFS_DIR}/usr/bin/"
mv "${ROOTFS_DIR}/usr/bin/${PARITY_BINARY_NAME}" "${ROOTFS_DIR}/usr/bin/parity"
install -m 644 files/parity.service "${ROOTFS_DIR}/etc/systemd/system/"

on_chroot << EOF
if [ "${IS_TESTNET}" == "1" ]; then
	curl -o /etc/parity/spec.json  https://raw.githubusercontent.com/DucatusX/ducatusx/master/configs/testnet/chain.json
	curl -o /etc/parity/snapshot_data.tar.gz https://bld.rocknblock.io/ducatus/ducatusx-testnet-snapshot-latest.tar.gz
else
	curl -o /etc/parity/spec.json  https://raw.githubusercontent.com/DucatusX/ducatusx/master/configs/mainnet/chain.json
	curl -o /etc/parity/snapshot_data.tar.gz https://bld.rocknblock.io/ducatus/ducatusx-mainnet-snapshot-latest.tar.gz
fi

tar xvf /etc/parity/snapshot_data.tar.gz -C /etc/parity/snapshot_data
mv /etc/parity/snapshot_data/data/chains /etc/parity/chains

rm -rf /etc/parity/snapshot_data
rm -rf /etc/parity/snapshot_data.tar.gz

systemctl enable parity
EOF
