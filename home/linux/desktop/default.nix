{ pkgs, ... }:
{
  imports = [
    ./creative.nix
    ./media.nix
    ./firefox.nix
  ];

  home.packages = with pkgs; [
    # instant messaging
    telegram-desktop

    # remote desktop(rdp connect)
    remmina
    freerdp # required by remmina

    # misc
    flameshot
    obsidian
  ];
}