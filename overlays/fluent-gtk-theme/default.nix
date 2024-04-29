{ channels, ... }:
(final: prev: {
  fluent-gtk-theme = (channels.nixpkgs-unstable.fluent-gtk-theme.overrideAttrs (finalAttrs: previousAttrs: {
    #version = "e4c25110e7095b74ee5fe849c0aae6f2f6e9f014";
  })).override {
    tweaks = [
      "round"
      "blur"
      "noborder"
    ];
  };
})
