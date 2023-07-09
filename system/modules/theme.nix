{ config, lib, ... }:
let 
  theme = config.theme.catppuccin-macchiato-theme; 
in
{
  options.theme = with lib; with lib.types; {

    font = mkOption { type = str; default = "Hack Nerd Font"; };

    colours =  {
      
      accent = mkOption { type = str; default = "#202335"; };

      black = mkOption { type = str; default =theme.crust; };
      white = mkOption { type = str; default =theme.rosewater; };

      pink = mkOption { type = str; default =theme.pink; };
      lightPink = mkOption { type = str; default =theme.flamingo; };

      red = mkOption { type = str; default =theme.red; };
      lightRed = mkOption { type = str; default =theme.maroon; };

      orange = mkOption { type = str; default =theme.peach; };
      yellow = mkOption { type = str; default =theme.yellow; };

      green = mkOption { type = str; default =theme.green; };
      cyan = mkOption { type = str; default =theme.teal; };

      blue = mkOption { type = str; default =theme.sapphire; };
      darkBlue = mkOption { type = str; default =theme.blue; };
      lightBlue = mkOption { type = str; default =theme.sky; };

      purple = mkOption { type = str; default =theme.mauve; };
      lightPurple = mkOption { type = str; default =theme.lavender; };

      subtext0 = mkOption { type = str; default =theme.subtext0; };
      subtext1 = mkOption { type = str; default =theme.subtext1; };
      text = mkOption { type = str; default =theme.text; };

      overlay0 = mkOption { type = str; default =theme.overlay0; };
      overlay1 = mkOption { type = str; default =theme.overlay1; };
      overlay2 = mkOption { type = str; default =theme.overlay2; };

      surface0 = mkOption { type = str; default =theme.surface0; };
      surface1 = mkOption { type = str; default =theme.surface1; };
      surface2 = mkOption { type = str; default =theme.surface2; };

      bg = mkOption { type = str; default =theme.base; };
      bgDark = mkOption { type = str; default =theme.mantle; };

    };

    catppuccin-macchiato-theme = {
  
      rosewater = mkOption { type = str; default = "#f4dbd6"; };
      flamingo = mkOption { type = str; default ="#f0c6c6"; };
      pink = mkOption { type = str; default ="#f5bde6"; };
      mauve = mkOption { type = str; default ="#c6a0f6"; };
      red = mkOption { type = str; default ="#ed8796"; };
      maroon = mkOption { type = str; default ="#ee99a0"; };
      peach = mkOption { type = str; default ="#f5a97f"; };
      yellow = mkOption { type = str; default ="#eed49f"; };
      green = mkOption { type = str; default ="#a6da95"; };
      teal = mkOption { type = str; default ="#8bd5ca"; };
      sky = mkOption { type = str; default ="#91d7e3"; };
      sapphire = mkOption { type = str; default ="#7dc4e4"; };
      blue = mkOption { type = str; default ="#8aadf4"; };
      lavender = mkOption { type = str; default ="#b7bdf8"; };

      subtext0 = mkOption { type = str; default ="#a5adcb"; };
      subtext1 = mkOption { type = str; default ="#b8c0e0"; };
      text = mkOption { type = str; default ="#cad3f5"; };

      overlay0 = mkOption { type = str; default ="#6e738d"; };
      overlay1 = mkOption { type = str; default ="#8087a2"; };
      overlay2 = mkOption { type = str; default ="#939ab7"; };

      surface0 = mkOption { type = str; default ="#363a4f"; };
      surface1 = mkOption { type = str; default ="#494d64"; };
      surface2 = mkOption { type = str; default ="#5b6078"; };

      base = mkOption { type = str; default = "#24273a"; };
      crust = mkOption { type = str; default = "#181926"; };
      mantle = mkOption { type = str; default = "#1e2030"; };
    };
  
  };

}
