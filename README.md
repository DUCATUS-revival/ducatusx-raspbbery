# DucatusX Raspberry Pi image generator

Tool used to create Raspberry Pi OS images with DucatusX node installed.


## Dependencies

pi-gen runs on Debian-based operating systems.

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

 * `PARITY_BINARY_DIR` **required** (Default: unset)

   Directory of parity binary file

 * `PARITY_BINARY_NAME` **required** (Default: unset)

   Parity binary file name. Can be generated with https://github.com/Rock-n-Block/parity-aarch64-builder

 * `IS_TESTNET` (Default: `0`)

   Setting to `1` will deploy DucatusX testnet node

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
  
    Setting to `1` will disable password authentication for SSH and enable public key authentication.  Note that if SSH is not enabled this will take effect when SSH becomes enabled.

 * `STAGE_LIST` (Default: `"stage0 stage1 stage2"`)

    If set, then instead of working through the numeric stages in order, this list will be followed. For example setting to `"stage0 stage1 mystage stage2"` will run the contents of `mystage` before stage2. Note that quotes are needed around the list. An absolute or relative path can be given for stages outside the pi-gen directory.

A simple example for building Raspbian:

```bash
PUBKEY_SSH_FIRST_USER='ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDrQ0RaIdjcFB7IPkcTTeSpfiCdp9XRoFxNwalVvz/w8FWEs4AArRdnOz/qazsL7OQ6vD9Jxdk05VNrsYJdgNRp1tqpVTfReFwjHkSpKrcb6bN8unccUt6/kBjdfrtWMXQsZB2ArTlOeCRn2GT4Kq5MR0vproQ+Kh1AjtOrnuWolKcYEodDRGSUwMOs4Y4XczxD7XzAX3TWMAPwHkyaXTpjndoAUodIyQV+xO9gfwKRD9Opm4KUbIW2t1vhilicWay+xmbckaANnHO4dTLNrU7ze9lAD0YPiscIWadOIv1180c7DOClB4uiOqZZ6MYjYpE6ILz/SoC/n6yEnN13b37/fOdB+TjaqWs1e/3OG6S69N95yXxIN5DS4ew8YdZd5mneBr1d/K9yUclXHijbi2dp57eQ2jhAl34DXL9zDm6aKBylSMymi274LZMa1QrPMErh1z9gCeovqjwvTlv3toNpQWuShdyYkN3XsoV/8tiTyZ+F0am77wy1KjJcK/ywids='

AWS_DEPLOY=1
AWS_S3_BUCKET_NAME=my-raspberry-images
AWS_S3_BUCKET_DIR=debug
AWS_CLI_PROFILE=main

PARITY_BINARY_DIR=/home/ubuntu/parity-aarch64-builder
PARITY_BINARY_NAME=parity
PARITY_PRIVATE_KEYS='b233ca35bc9b3884ccd255a290bab0476eb07fcdab541dac9d990ec13bde1179
c797a611c006ed2f644bc43d2316a9a2a274f601572ce36f5379b1d0957371a5
8aed43f1ff4b962263e349b3fee4c0564570229980bbaec9121689b3fc7b5292
73dc32f7004c67e37723ad2e6592839b7ef8cb2816bb51c06ca93220c7ffd10f'
```
## Run
The config file can also be specified on the command line as an argument of the `build.sh` script.


```
./build.sh -c myconfig
```

This is parsed after `config` so can be used to override values set there.

Please run `build.sh` with sudo!

