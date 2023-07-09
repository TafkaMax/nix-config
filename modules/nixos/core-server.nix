{ lib, variables, pkgs, ... }:

{

  # TODO add boot support without encrypted disk here in the future.

  nix = {
    settings = {
      sandbox = true;
      trusted-users = [ "@wheel" "${variables.username}" ];
      allowed-users = [ "@wheel" ];
      # Manual optimise storage: nix-store --optimise
      # https://nixos.org/manual/nix/stable/command-ref/conf-file.html#conf-auto-optimise-store
      auto-optimise-store = true;
      # enable flakes globally
      experimental-features = [ "nix-command" "flakes"];
    };
    package = pkgs.nixFlakes;
    # do garbage collection weekly to keep disk usage low
    gc = {
      automatic = lib.mkDefault true;
      dates = lib.mkDefault "weekly";
      options = lib.mkDefault "--delete-older-than 1w --max-freed $((64 * 1024**3))";
    };
    optimise = {
      automatic = true;
      dates = [ "weekly" ];
    };
  };

  # Allow unfree packages
  nixpkgs = {
    config = {
      allowUnfree = true;
      allowBroken = false;
    };
  };

  # Set your time zone.
  time.timeZone = "Europe/Tallinn";

  # Select internationalization properties.
  i18n = {
    defaultLocale = "en_US.UTF-8";
    supportedLocales = [ "en_US.UTF-8/UTF-8" "et_EE.UTF-8/UTF-8" ];
  };

  console = {
    keyMap = "us";
  };

  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  networking.firewall.enable = lib.mkDefault false;

  # Enable the OpenSSH daemon.
  services.openssh = {
    enable = true;
    settings = {
      X11Forwarding = true;
      PermitRootLogin = "no"; # disable root login
      PasswordAuthentication = false; # disable password login
    };
    openFirewall = true;
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    neovim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
    curl
    git # used by nix flakes
    rsync
    zsh
  ];

  # replace default editor with neovim
  environment.variables.EDITOR = "nvim";

  virtualisation.docker = {
    enable = true;
    autoPrune.enable = true;
    enableOnBoot = true;
  };

  # for power management
  services.power-profiles-daemon = {
    enable = true;
  };
  services.upower.enable = true;
}