{ config, pkgs, lib, ... }:
{
  users.users.snd = {
    uid = 1000;
    isNormalUser = true;
    description = "snd";
    extraGroups = [ "podman" "journalctl" "docker" "libvirtd" "video" "adbusers" "networkmanager" "wheel" ];
  };
}
