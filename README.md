# NixOS setup

## Inspiration

1. https://mudrii.medium.com/nixos-native-flake-deployment-with-luks-drive-encryption-and-lvm-b7f3738b71ca
2. https://github.com/NixOS/nixos-hardware
3. https://github.com/ryan4yin/nix-config
4. https://nixos-and-flakes.thiscute.world/

## Setup

## First Install

For your first install / inital setup, please refer to [README-first-time-install.md](README-first-time-install.md)

## Workflow

### Usage

- Updating lock file.
  - `sudo nix flake update /etc/nixos`
- Update system
  - `sudo nixos-rebuild switch --flake /etc/nixos/flake.nix#nixos_custom

### Structure

1. `flake.nix`
   1. your-computer-hostname in `flake.nix` will import your computer setup.
2. `hosts/your-computer-hostname` folder will contain
   1. `default.nix`
      1. Will import specific things for your setup.
   2. `hardware-configuration.nix`
      1. Hardware configuration for your specific setup.