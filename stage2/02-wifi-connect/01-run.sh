#!/bin/bash -e

mkdir -p "${ROOTFS_DIR}/etc/wifi-connect"
install -m 700 scripts/start.sh "${ROOTFS_DIR}/etc/wifi-connect/"
install -m 644 files/wifi-connect.service "${ROOTFS_DIR}/etc/systemd/system/"

on_chroot << EOF
_wfc_repo='balena-os/wifi-connect'
_wfc_install_root='/usr/'
_install_bin_dir="$_wfc_install_root/sbin"
_install_ui_dir="$_wfc_install_root/share/wifi-connect/ui"
_release_url="https://api.github.com/repos/$_wfc_repo/releases/latest"
_regex='browser_download_url": "\K.*aarch64\.tar\.gz'

echo "Retrieving latest release from $_release_url..."

_arch_url=$(curl "$_release_url" -s | grep -hoP "$_regex")

echo "Downloading and extracting $_arch_url..."

_download_dir=$( mktemp -d)

curl -Ls "$_arch_url" | tar -xz -C "$_download_dir"

sudo mv "$_download_dir/wifi-connect" $_install_bin_dir

sudo mkdir -p $_install_ui_dir

sudo rm -rdf $_install_ui_dir

sudo mv "$_download_dir/ui" $_install_ui_dir

rm -rdf "$_download_dir"

_wfc_version=$( wifi-connect --version)

echo "Successfully installed $_wfc_version"

systemctl enable wifi-connect
EOF