# Podman Aseprite container

this repository is a fork of [nilsve/docker-aseprite-linux](https://github.com/nilsve/docker-aseprite-linux) which is nice on its own.
However, it uses podman instad of Docker along with a few cahnges to the make file.

The version 

This repository allows you to compile Aseprite without installing any build tools. All that is required is Podman.

If any of the folders of the projects folder isn't empty, the script will skip checking out the latest versions. In order to re-download, delete the following folder.
* ./dependencies/depot_tools
* ./dependencies/skia
* ./output/aseprite

## Usage
 * Install [Podman](https://podman.io/docs/installation)
 * Clone this repository 
 * cd into cloned repository
 * Run `make all`
 * Grab a cup of coffee, since this can take quite a while (Compiling build deps, skia, and aseprite)

You can now find the compiled version of Aseprite in the `output/aseprite/build/bin` folder

## FAQ
If you get the following error when running Aseprite: `./aseprite: error while loading shared libraries: libdeflate.so.0: cannot open shared object file: No such file or directory`, make sure you have libdeflate installed on your system. Please run
`sudo apt install -y libdeflate0 libdeflate-dev`

If you get the following error: `./aseprite: error while loading shared libraries: libcrypto.so.1.1: cannot open shared object file: No such file or directory`, you'll want to install the OpenSSL 1.1 package/library. You may have only OpenSSL 3.x installed, meanwhile Aseprite still uses the v1.1 library.
* On Arch / Arch based distros, run `sudo pacman -Syu openssl-1.1`
* On Ubuntu try: `sudo apt install -y libssl1.1`
