{ config, pkgs, lib, ... }:
{
    setup = {
        hostname = "thinkpad";
        keyboard = "de";
        mail.enable = true;
        gui.enable = true;
        dnscrypt.enable = true;
        libvirt.enable = true;
        plymouth.enable = true;
        bluetooth.enable = true;
        screen = "small";
    };

    networking.networkmanager.enable = true;
    networking.interfaces.enp3s0.useDHCP = true;

    imports = [
        ./services/dns-crypt.nix
        ./services/wireguard-client.nix
        ./services/syncthing.nix
        ./hardware_thinpad_e480.nix
        ../../configuration.nix
    ];

}
