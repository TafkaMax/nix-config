{ config, lib, ... }:
let 
    ge = config.setup.gui.enable;
in
{
  programs.gnupg.agent = {
    enable = true;
    pinentryFlavor = if ge == true then "gnome3" else "tty";
  };

  programs.ssh.startAgent = true;
  services.gnome.gnome-keyring.enable = ge; # spot requires gnome-keyring
}
