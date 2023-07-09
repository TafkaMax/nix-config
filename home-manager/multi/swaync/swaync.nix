{ pkgs, lib, ...}:

{
  home.file."swaync-config".source = ./config.json;
  home.file."swaync-config".target = ".config/swaync/config.json";
  home.file."swaync-style".source = ./style.css;
  home.file."swaync-style".target = ".config/swaync/style.css";
  home.file."swaync-schema".source = ./configSchema.json;
  home.file."swaync-schema".target = ".config/swaync/configSchema.json";
}
