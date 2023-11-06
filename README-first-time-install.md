# First Time Install

Create a bootable NixOS installer USB. https://nixos.org/download.html

After booting from the USB, clone this to repo to `~/nix-config` e.g `sudo git clone git@github.com:TafkaMax/nix-config.git`

## Partitioning

For first time install, the disks need to be modified and **partitions** need to be made. Partitions can be created using `setup_disks.sh` script.

## setup_disks.sh

This script expects a single input, your disk name.
1. e.g. For modern Laptops/Desktops you are using a **NVME** drive which would be under `/dev/` as `nvme0n1`.
2. e.g. For older systems with **SATA*** drive, it would be under `/dev` as `sda`.

This script creats the following partitions on your drive:

1. 512MB boot parition
2. The rest of the available disk space will be used for a **encrypted** drive, that uses LVM on top.

### Example usage.

`./setup_disks.sh nvme0n1`

## Create crypted partition.

```bash
# Setting up LUKS
# Create a luks encrypted partition and set the password.
cryptsetup luksFormat /dev/disk/by-partlabel/root
# Open the partition to work on it.
cryptsetup luksOpen /dev/disk/by-partlabel/root root
# Create a physical volume on the now opened encrypted partition.
pvcreate /dev/mapper/root
# Create a virtual group on the now opened encryption partition.
vgcreate vg /dev/mapper/root
# Setting up LVM disks
# Create a logical volume on the volume group you just created for your SWAP. Check how much RAM you have and based on that.
lvcreate -L 20G -n swap vg
# The rest of the available space goes to the root / logical volume, which will host your OS.
lvcreate -l '100%FREE' -n root vg
# Create a FAT filesystem for your boot partition.
mkfs.fat -F 32 -n boot /dev/disk/by-partlabel/boot
# Create an ext4 or whatever filesystem you like on the root logical volume.
mkfs.ext4 -L root /dev/vg/root
# Create a swap on the logical volume you created for swap.
mkswap -L swap /dev/vg/swap

# Mounting for installation.
mount /dev/disk/by-label/root /mnt
mkdir -p /mnt/boot
mount /dev/disk/by-label/boot /mnt/boot
swapon /dev/vg/swap
swapon -s
```
## Install your nixos system

```bash
# Prerequisities
nix-shell -p git nixFlakes
# Make the etc folder if it is not yet present.
mkdir /mnt/etc
# Depending on the version of your nixos installer you can't use symlink.
git clone https://github.com/ExampleUserName/nix-config /mnt/etc/nixos
# Upgrade the flakes.
nix --extra-experimental-features "nix-command flakes"  flake update /mnt/etc/nixos
# Install
nixos-install --root /mnt --flake /mnt/etc/nixos#HOSTNAME
```

## Tasks after installing

NixOS uses `/etc/nixos` as its base configuration. The files there are owned by root and managing it with git can be cumbersome. It is recommended to create a symlink from your user directory.

```bash
sudo mv /etc/nixos /etc/nixos.bak  # Backup the original configuration
# Symlink the repository you are using to /etc/nixos
sudo ln -s /path/to/nix-config/ /etc/nixos
# Change directory to your config dir.
cd /path/to/nix-config
# Deploy the flake.nix located at the default location (/etc/nixos)
sudo nixos-rebuild switch
# Or when using this repository, you can use the Makefile commands.
make deploy
```
