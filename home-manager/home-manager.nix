{ pkgs, config, lib, ... }:
{
  home-manager.users.snd = { nixosConfig, config, pkgs, ... }: {
    home.stateVersion = "22.11";
    imports = [
      ./single/alacritty.nix
      ./single/bspwm.nix  
      ./single/git.nix
      ./single/gtk.nix
      ./single/mail.nix
      ./single/mpv.nix
      ./single/ncmpcpp.nix
      ./single/qutebrowser.nix
      ./single/rclone.nix
      ./single/rofi.nix
      ./single/sway.nix
      ./single/waybar.nix
      ./single/wofi.nix
      ./single/xdg.nix
      ./single/zathura.nix
      ./single/bat.nix
      ./single/librewolf.nix
      ./single/cli-visuializer.nix
      ./single/mpd.nix
      ./single/shell.nix
      ./single/tmux.nix

      ./multi/polybar/polybar.nix
      ./multi/nnn/nnn.nix
      ./multi/swaync/swaync.nix
      ./multi/swaylock/swaylock.nix
      ./multi/network-certs/network-certs.nix
      ./multi/nvim/nvim.nix
    ];
  };

  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;

}
