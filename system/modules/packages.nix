{ config, lib, pkgs, ... }:
let
  unstable = import (builtins.fetchTarball {
    url = config.channel.unstable.default.url;
    sha256 = config.channel.unstable.default.sha256;
  }) { };
in
{
  nixpkgs.config = {
    allowUnfree = true;
    packageOverrides = pkgs: {
      unstable = import (builtins.fetchTarball { 
        url = "https://github.com/NixOS/nixpkgs/archive/21951114383770f96ae528d0ae68824557768e81.tar.gz";
        sha256 = "003vyfhn84snj5x1h9zm61njh80cmgdfz0kjwmxri8rsb54psyca";
      }) { config = config.nixpkgs.config; };
    };
  };

  environment.systemPackages = with pkgs; [
    htop
    ripgrep
    smartmontools
    podman-tui
    rclone 
    xdg-utils
    gnupg
    nvtop-amd
    git-crypt
    neofetch
    wget
    hd-idle
    gdb
    duf
    gdu
    pinentry
    pass
    bmon
    nload
    gitui
    git-filter-repo
    lua
    apacheHttpd
    qrencode
  ];
}
