{
  config,
  lib,
  pkgs,
  namespace,
  ...
}:

with lib;
with lib.${namespace};
let
  cfg = config.${namespace}.tools.misc;
in
{
  options.${namespace}.tools.misc = with types; {
    enable = mkBoolOpt false "Whether or not to enable common utilities.";
  };

  config = mkIf cfg.enable {
    ${namespace}.home.configFile."wgetrc".text = "";

    environment.systemPackages = with pkgs; [
      # archives
      zip
      xz
      unzip
      cabextract

      # utils
      ripgrep # recursively searches directories for a regex pattern
      jq # A lightweight and flexible command-line JSON processor
      yq-go # yaml processer https://github.com/mikefarah/yq
      fzf # A command-line fuzzy finder

      # networking tools
      iperf3
      # iperf2 for multicast support
      iperf2
      # tcpdump for debugging
      tcpdump
      dnsutils # `dig` + `nslookup`
      ldns # replacement of `dig`, it provides the command `drill`
      socat # replacement of openbsd-netcat
      nmap # A utility for network discovery and security auditing
      ipcalc # it is a calculator for the IPv4/v6 addresses
      inetutils
      mtr # diagnostics tool
      mtr-gui

      # misc
      file
      which
      tree
      gnupg
      killall
      clac
      lshw
      usbutils
      iw

      # embedded development
      # console
      minicom

      # Disk utils
      smartmontools
    ];
  };
}
