{ options, config, lib, pkgs, ... }:

with lib;
with lib.nixos-snowfall;
let cfg = config.nixos-snowfall.tools.misc;
in
{
  options.nixos-snowfall.tools.misc = with types; {
    enable = mkBoolOpt false "Whether or not to enable common utilities.";
  };

  config = mkIf cfg.enable {
    nixos-snowfall.home.configFile."wgetrc".text = "";

    environment.systemPackages = with pkgs; [
      # archives
      zip
      xz
      unzip

      # utils
      ripgrep # recursively searches directories for a regex pattern
      jq # A lightweight and flexible command-line JSON processor
      yq-go # yaml processer https://github.com/mikefarah/yq
      fzf # A command-line fuzzy finder

      # networking tools
      iperf3
      dnsutils # `dig` + `nslookup`
      ldns # replacement of `dig`, it provides the command `drill`
      socat # replacement of openbsd-netcat
      nmap # A utility for network discovery and security auditing
      ipcalc # it is a calculator for the IPv4/v6 addresses

      # misc
      file
      which
      tree
      gnupg
      killall
      clac

      # embedded development
      # console
      minicom
    ];
  };
}
