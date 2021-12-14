# DucatusX Raspberry Pi image generator

Tool used to create Raspberry Pi OS images. (Previously known as Raspbian).


## Dependencies

pi-gen runs on Debian-based operating systems. Currently it is only supported on
either Debian Buster or Ubuntu Xenial and is known to have issues building on
earlier releases of these systems. On other Linux distributions it may be possible
to use the Docker build described below.

To install the required dependencies for `pi-gen` you should run:

```bash
apt-get install coreutils quilt parted qemu-user-static debootstrap zerofree zip \
dosfstools libarchive-tools libcap2-bin grep rsync xz-utils file git curl bc \
qemu-utils kpartx
```

The file `depends` contains a list of tools needed.  The format of this
package is `<tool>[:<debian-package>]`.


## Config

Upon execution, `build.sh` will source the file `config` in the current
working directory.  This bash shell fragment is intended to set needed
environment variables.

The following environment variables are supported:

 * `PARITY_PRIVATE_KEYS` **required** (Default: unset)

   List of parity workers private keys.

 * `PARITY_BINARY` **required** (Default: unset)

   Path to parity binary file. Can be generated with https://github.com/Rock-n-Block/parity-aarch64-builder

 * `IMG_NAME` (Default: `"DucatusxRaspbian"`)

   The name of the image to build with the current stage directories.  Setting
   `IMG_NAME=Raspbian` is logical for an unmodified RPi-Distro/pi-gen build,
   but you should use something else for a customized version.  Export files
   in stages may add suffixes to `IMG_NAME`.

 * `DEPLOY_ZIP` (Default: `0`)

   Setting to `0` will deploy the actual image (`.img`) instead of a zipped image (`.zip`).

 * `TARGET_HOSTNAME` (Default: "raspberrypi" )

   Setting the hostname to the specified value.

 * `FIRST_USER_NAME` (Default: "pi" )

   Username for the first user

 * `FIRST_USER_PASS` (Default: "raspberry")

   Password for the first user

 * `WPA_ESSID`, `WPA_PASSWORD` and `WPA_COUNTRY` (Default: unset)

   If these are set, they are use to configure `wpa_supplicant.conf`, so that the Raspberry Pi can automatically connect to a wireless network on first boot. If `WPA_ESSID` is set and `WPA_PASSWORD` is unset an unprotected wireless network will be configured. If set, `WPA_PASSWORD` must be between 8 and 63 characters.

 * `ENABLE_SSH` (Default: `1`)

   Setting to `1` will enable ssh server for remote log in. Note that if you are using a common password such as the defaults there is a high risk of attackers taking over you Raspberry Pi.

  * `PUBKEY_SSH_FIRST_USER` (Default: unset)
   Setting this to a value will make that value the contents of the FIRST_USER_NAME's ~/.ssh/authorized_keys.  Obviously the value should
   therefore be a valid authorized_keys file.  Note that this does not
   automatically enable SSH.

  * `PUBKEY_ONLY_SSH` (Default: `1`)

   * Setting to `1` will disable password authentication for SSH and enable
   public key authentication.  Note that if SSH is not enabled this will take
   effect when SSH becomes enabled.

 * `STAGE_LIST` (Default: `"stage0 stage1 stage2"`)

    If set, then instead of working through the numeric stages in order, this list will be followed. For example setting to `"stage0 stage1 mystage stage2"` will run the contents of `mystage` before stage2. Note that quotes are needed around the list. An absolute or relative path can be given for stages outside the pi-gen directory.

A simple example for building Raspbian:

```bash
IMG_NAME='Raspbian'
```

The config file can also be specified on the command line as an argument the `build.sh` or `build-docker.sh` scripts.

```
./build.sh -c myconfig
```

This is parsed after `config` so can be used to override values set there.

