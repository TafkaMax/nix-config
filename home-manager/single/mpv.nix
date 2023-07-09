{ pkgs, lib, ...}:

{
  home.file."mpv.conf".text = ''
image-display-duration=inf
  '';
  home.file."mpv.conf".target = ".config/mpv/mpv.conf";
}
