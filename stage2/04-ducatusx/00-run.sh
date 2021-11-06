#!/bin/bash -e

jinja2 files/config.toml.j2 -D node_eth_address="${NODE_ETH_ADDRESS}" -o config.toml
install -m 644 config.toml "${ROOTFS_DIR}/var/"
install -m 700 "${PARITY}" "${ROOTFS_DIR}/var/"
