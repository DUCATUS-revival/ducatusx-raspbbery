#!/bin/bash -e

WFC_REPO='balena-os/wifi-connect'
WFC_INSTALL_ROOT='${ROOTFS_DIR}/usr/local'
NAME='WiFi Connect Raspbian Installer'

INSTALL_BIN_DIR="$WFC_INSTALL_ROOT/sbin"
INSTALL_UI_DIR="$WFC_INSTALL_ROOT/share/wifi-connect/ui"

RELEASE_URL="https://api.github.com/repos/$WFC_REPO/releases/latest"

main() {
    install_wfc
}

install_wfc() {
    local _regex='browser_download_url": "\K.*aarch64\.tar\.gz'
    local _arch_url
    local _wfc_version
    local _download_dir

    say "Retrieving latest release from $RELEASE_URL..."

    _arch_url=$(ensure curl "$RELEASE_URL" -s | grep -hoP "$_regex")

    say "Downloading and extracting $_arch_url..."

    _download_dir=$(ensure mktemp -d)

    say "Download dir: $_download_dir"

    ensure curl -Ls "$_arch_url" | tar -xz -C "$_download_dir"

    ensure install -m 700 "$_download_dir/wifi-connect" $INSTALL_BIN_DIR
    ensure install -d $INSTALL_UI_DIR
    ensure mv "$_download_dir/ui/*" $INSTALL_UI_DIR
    ensure install -d "${ROOTFS_DIR}/etc/wifi-connect"
    ensure install -m 700 scripts/start.sh "${ROOTFS_DIR}/etc/wifi-connect/"
    ensure install -m 644 files/wifi-connect.service "${ROOTFS_DIR}/etc/systemd/system/"
    ensure rm -rdf "$_download_dir"
    say "Successfully installed"
}

say() {
    printf '\33[1m%s:\33[0m %s\n' "$NAME" "$1"
}

ensure() {
    "$@"
    if [ $? != 0 ]; then
        err "command failed: $*";
    fi
}

main "$@" || exit 1