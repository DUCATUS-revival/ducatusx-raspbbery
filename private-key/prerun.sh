#!/bin/bash -e

if [ ! -d "${ROOTFS_DIR}" ]; then
	STAGE2_ROOTFS_DIR="${WORK_DIR}/stage2/rootfs"
	if [ ! -d "${STAGE2_ROOTFS_DIR}" ]; then
		echo "Stage2 rootfs not found"
		false
	fi
	mkdir -p "${ROOTFS_DIR}"

	rsync -aHAXx --exclude var/cache/apt/archives "${STAGE2_ROOTFS_DIR}/" "${ROOTFS_DIR}/"
fi
