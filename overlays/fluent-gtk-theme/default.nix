{ channels, ... }:
(final: prev: {
  fluent-gtk-theme = channels.nixpkgs-unstable.fluent-gtk-theme.override {
    tweaks = [
      "round"
      "blur"
      "noborder"
    ];
  };
})
