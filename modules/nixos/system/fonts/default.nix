{ options, config, pkgs, lib, ... }:

with lib;
with lib.nixos-snowfall;
let cfg = config.nixos-snowfall.system.fonts;
in
{
  options.nixos-snowfall.system.fonts = with types; {
    enable = mkBoolOpt false "Whether or not to manage fonts.";
    fonts = mkOpt (listOf package) [ ] "Custom font packages to install.";
  };

  config = mkIf cfg.enable {
    environment.variables = {
      # Enable icons in tooling since we have nerdfonts.
      LOG_ICONS = "true";
    };

    environment.systemPackages = with pkgs; [ font-manager ];

    fonts = {
      fontDir.enable = true;
      packages = with pkgs;
        [
          noto-fonts
          noto-fonts-cjk-sans
          noto-fonts-cjk-serif
          noto-fonts-emoji
          powerline-fonts
          material-design-icons
          font-awesome
          dejavu-fonts
          (nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
        ] ++ cfg.fonts;

      # Set default fonts.
      fontconfig.defaultFonts = {
        serif = [ "Noto Serif" "Noto Color Emoji" ];
        sansSerif = [ "Noto Sans" "Noto Color Emoji" ];
        monospace = [ "JetBrainsMono Nerd Font" "Noto Color Emoji" ];
        emoji = [ "Noto Color Emoji" ];
      };
    };
  };
}
