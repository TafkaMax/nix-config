{ options, config, pkgs, lib, ... }:

with lib;
with lib.internal;
let
  cfg = config.nixos-snowfall.hardware.audio;
in
{
  options.nixos-snowfall.hardware.audio = with types; {
    enable = mkBoolOpt false "Whether or not to enable audio support.";
    alsa-monitor = mkOpt attrs { } "Alsa configuration.";
    nodes = mkOpt (listOf attrs) [ ]
      "Audio nodes to pass to Pipewire as `context.objects`.";
    modules = mkOpt (listOf attrs) [ ]
      "Audio modules to pass to Pipewire as `context.modules`.";
    extra-packages = mkOpt (listOf package) [
    ] "Additional packages to install.";
  };

  config = mkIf cfg.enable {
    # rtkit is optional but recommended
    security.rtkit.enable = true;

    # Remove sound.enable or turn it off if you had it set previously, it seems to cause conflicts with pipewire
    sound.enable = false;

    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = true;
    };

    # Disable pulseaudio, it conflicts with pipewire too.
    hardware.pulseaudio.enable = mkForce false;
  };
}
