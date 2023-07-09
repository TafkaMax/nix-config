{ config, lib, pkgs, ... }:
let
  home-manager = builtins.fetchTarball {
    url = "https://github.com/nix-community/home-manager/archive/e753d659c64c7d158433d87ef7d6151ca1d1817a.tar.gz";
    sha256 = "0kahrafm6z2ns3p6ixcf8cmz8l3g5q3aal7vcdxmg4xymxyhp36g";
  };
in
{
  imports = [ 
    (import "${home-manager}/nixos") 
    ./home-manager/home-manager.nix
    ./system/modules/modules.nix
    ./system/systemd/systemd.nix
    ./system/pkgs/overlays.nix
    ./nixos_secrets/secret-options.nix
   ];

  time.timeZone = "Europe/Berlin";
  i18n.defaultLocale = "en_US.UTF-8";
  console.keyMap = config.setup.keyboard;

  networking.hostName = config.setup.hostname;
  
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "de_DE.UTF-8";
    LC_IDENTIFICATION = "de_DE.UTF-8";
    LC_MEASUREMENT = "de_DE.UTF-8";
    LC_MONETARY = "de_DE.UTF-8";
    LC_NAME = "de_DE.UTF-8";
    LC_NUMERIC = "de_DE.UTF-8";
    LC_PAPER = "de_DE.UTF-8";
    LC_TELEPHONE = "de_DE.UTF-8";
    LC_TIME = "de_DE.UTF-8";
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.11"; # Did you read the comment?
}
