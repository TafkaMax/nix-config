# First Time Install

Create a bootable NixOS installer USB. https://nixos.org/download.html

After booting from the USB, clone this to repo to `~/nixconf` e.g `sudo git clone git@github.com:TafkaMax/nixconf.git ~/nixconf`

## Paritioning

For first time install, the disks need to be modified and **partitions** need to be made.

Partitions can be created using `setup_disks.sh` script

## setup_disks.sh

This script expects a single input, your disk name. 
1. e.g. For modern Laptops/Desktops you are using a **NVME** drive which would be under `/dev/` as `nvme0n1`.
2. e.g. For older systems with **SATA*** drive, we would be under `/dev` as `sda`.

This script creats the fellowing partition on your drive:

1. 512MB boot parition
2. The rest of the available disk space will be used for a **encrypted** drive, that uses LVM on top.

### Example usage.

`./setup_disks.sh nvme0n1`

## Create crypted partition.

```bash
# Setting up LUKS
cryptsetup luksFormat /dev/disk/by-partlabel/root
cryptsetup luksOpen /dev/disk/by-partlabel/root root
pvcreate /dev/mapper/root
vgcreate vg /dev/mapper/root
# Setting up LVM disks
lvcreate -L 20G -n swap vg
lvcreate -l '100%FREE' -n root vg
mkfs.fat -F 32 -n boot /dev/disk/by-partlabel/boot
mkfs.ext4 -L root /dev/vg/root
mkswap -L swap /dev/vg/swap

# Mounting for installation
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
# Install
nixos-install --root /mnt --flake /mnt/etc/nixos#HOSTNAME
```

## Tasks after installing

NixOS uses `/etc/nixos` as its base configuration. The files there are owned by root and managing it with git can be cumbersome. It is recommended to create a symlink from your user directory.

```bash
sudo mv /etc/nixos /etc/nixos.bak  # Backup the original configuration
# Symlink the repository you are using to /etc/nixos
sudo ln -s ~/nixos-config/ /etc/nixos

# Deploy the flake.nix located at the default location (/etc/nixos)
sudo nixos-rebuild switch
```

## Secrets submodule

Rename `secrets` folder to point to your secret git repo.

Create a new repository for yourself where you will place your secrets and add it as a submodule: `git submodule add git@github.com:Username/nix-secrets.git secrets`