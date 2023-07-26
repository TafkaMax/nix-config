{ nixpkgs-unstable, ... }:
final: prev:
{
  fluent-gtk-theme = prev.nixpkgs-unstable.pkgs.fluent-gtk-theme.override {
    tweaks = [
      "round"
    ];
  };
}
