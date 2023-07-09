{ pkgs, ... }:
{
  home.packages = with pkgs; [
    # creative
    gimp # image editing
  ];

  programs = {
    # live streaming / recording
    obs-studio.enable = true;
  };
}