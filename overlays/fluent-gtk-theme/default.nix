{ pkgs, config, lib, ... }:

(self: super: {
  fluent-gtk-theme = super.fluent-gtk-theme.override { tweaks = [ "round" ]; };
})
