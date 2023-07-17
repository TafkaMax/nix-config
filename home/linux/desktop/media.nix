{ pkgs
, config
, ...
}:
# media - control and enjoy audio/video
{
  home.packages = with pkgs; [
    vlc
    spotify
  ];
}