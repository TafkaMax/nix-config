{ config, pkgs, lib, ... }:
{
    setup = {
        hostname = "desktop";
        keyboard = "us";
        mail.enable = true;
        gui.enable = true;
        libvirt.enable = true;
        plymouth.enable = true;
        screen = "big";
        scarlett.enable = true;
    };

    networking.networkmanager.enable = true;
    networking.interfaces.enp42s0.useDHCP = true;


    imports = [
        ./services/syncthing.nix
        ./hardware_desktop.nix
        ../../configuration.nix
    ];

}
