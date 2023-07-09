# NixOS

### How to clone this repo?

```sh
git clone --recursiv git@codeberg.org:snd/nixos_conf.git
```
### How to choose a device configuartion?
- add following line to ```/etc/nixos/configuration.nix```
```nix
# example
{ config, pkgs, ... }:
{
  imports = [ /home/snd/.nix-dots/machines/thinkpad_e480/setup.nix ];
}
```

### How to pull the latest commit of submodules?

1. Update submodule
- has to be done one every device after the update has been commited and pulled
```sh
git submodule update --recursive --remote
```
2. Commit 
```sh
git commit nixos_secrets -m "pulled latest secrets"
```

### I Screwed up and pushed/commited something in clear-text (method is not recommended)

```sh
git filter-repo --invert-paths --path <path to the file or directory>
```
