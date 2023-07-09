{ config, pkgs, lib, ... }:
{
options = with lib; with lib.types; {
    setup.plymouth.enable = mkEnableOption "Plymouth";
};

config = {
  boot = {
    loader = {
      systemd-boot = {
        enable = true;
        consoleMode = if config.setup.screen == "small" then "keep" else "0";
      };
      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/boot/efi";
      };
    };
    consoleLogLevel = 0;
    kernelParams = [ "quiet" "udev.log_level=3" ];
    initrd = {
      systemd.enable = config.setup.plymouth.enable; # required for plymouth
      verbose = false;
      secrets = {"/crypto_keyfile.bin" = null;};
    };
    plymouth = {
      enable = config.setup.plymouth.enable;
      themePackages = [ pkgs.adi1090x-plymouth ];
      theme = "abstract_ring";
      font = "${(pkgs.nerdfonts.override { fonts = [ "Hack" ]; })}/share/fonts/truetype/NerdFonts/HackNerdFont-Regular.ttf";
    };
  };
};
}
