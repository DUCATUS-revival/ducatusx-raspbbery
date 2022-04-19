#!/bin/bash -e

WFC_REPO='balena-os/wifi-connect'
WFC_INSTALL_ROOT="${ROOTFS_DIR}/usr/local"
NAME='WiFi Connect Raspbian Installer'

INSTALL_BIN_DIR="$WFC_INSTALL_ROOT/sbin"
INSTALL_UI_DIR="$WFC_INSTALL_ROOT/share/wifi-connect"

RELEASE_URL="https://api.github.com/repos/$WFC_REPO/releases/latest"

install_wfc() {
    local _regex='browser_download_url": "\K.*aarch64\.tar\.gz'
    local _arch_url
    local _download_dir

    say "Retrieving latest release from $RELEASE_URL..."

    _arch_url=$(curl "$RELEASE_URL" -s | grep -hoP "$_regex")

    say "Downloading and extracting $_arch_url..."

    _download_dir=$( mktemp -d)

    say "Download dir: $_download_dir"

    curl -Ls "$_arch_url" | tar -xz -C "$_download_dir"

    install -d $INSTALL_BIN_DIR
    install -m 700 "$_download_dir/wifi-connect" $INSTALL_BIN_DIR
    install -d $INSTALL_UI_DIR
    mv "$_download_dir/ui" $INSTALL_UI_DIR
    install -d "${ROOTFS_DIR}/etc/wifi-connect"
    install -m 700 scripts/start.sh "${ROOTFS_DIR}/etc/wifi-connect/"
    install -m 644 files/wifi-connect.service "${ROOTFS_DIR}/etc/systemd/system/"
    rm -rdf "$_download_dir"
    say "Successfully installed"
}

say() {
    printf '\33[1m%s:\33[0m %s\n' "$NAME" "$1"
}

install_wfc

on_chroot << EOF
systemctl enable wifi-connect
EOF