{ pkgs, ... }:
(final: prev: {
  fluent-gtk-theme = pkgs.fluent-gtk-theme.override {
    tweaks = [
      "round"
    ];
  };
})
