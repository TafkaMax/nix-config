# NixOS setup

## Inspiration

1. https://mudrii.medium.com/nixos-native-flake-deployment-with-luks-drive-encryption-and-lvm-b7f3738b71ca
3. https://github.com/ryan4yin/nix-config
4. https://nixos-and-flakes.thiscute.world/

## Setup

## First Install

For your first install / inital setup, please refer to [README-first-time-install.md](README-first-time-install.md) for instructions.

## Secrets

Information regarding `secrets` e.g. root password and so on, can be found here: [README-secrets.md](README-secrets.md).

## Usage

### Update pkgs e.g. `apt update`

Sometimes you need to update the `flake.lock` file to get new versions of programs. The command to update your pkgs versions is `nix flake update`, but the Makefile provided with this repository allows you to also use `make update`

### Install pkgs e.g. `apt upgrade / apt install`

To then install the new pkgs that have been configured in the `flake.lock` file you need to use `nixos-rebuild switch --flake . --use-remote-sudo`. The Makefile also provides a simpler command `make deploy` and a debug version of that named `make debug`.

## Structure

1. `flake.nix`
   1. your-computer-hostname in `flake.nix` will import your computer setup.
2. `hosts/your-computer-hostname` folder will contain
   1. `default.nix`
      1. Will import specific things for your setup.
   2. `hardware-configuration.nix`
      1. Hardware configuration for your specific setup.