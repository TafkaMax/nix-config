{ lib, variables, pkgs, ... }:

{
  imports = [
    ./core-server.nix
  ];

  # TODO move nonencrypted disks to core-server.nix
  # for desktops always use encrypted disk
  boot = {
	  loader = {
  		efi.canTouchEfiVariables = true;
		  systemd-boot.enable = false;
  		grub = {
  		  useOSProber = true;
  		  enable = true;
  		  efiSupport = true;
  		  enableCryptodisk = true;
  		  device = "nodev";
        # for nix server, we do not need to keep too much generations
        configurationLimit = 10;
  		};
	  };
  	initrd = {
		  availableKernelModules = [
			  "cryptd"
		  ];
		  luks.devices = {
    	  crypt = {
      		preLVM = true;
    	  };
		  };
    };
  };

  # to install chrome, you need to enable unfree packages
  nixpkgs.config.allowUnfree = lib.mkForce true;

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # DO NOT promote current-user to input password for `nix-store` and `nix-copy-closure`
  security.sudo.extraRules = [
    { users = [ "${variables.username}" ];
      commands = [
        { command = "/run/current-system/sw/bin/nix-store" ;
          options = [ "NOPASSWD" ];
        }
        { command = "/run/current-system/sw/bin/nix-copy-closure" ;
          options = [ "NOPASSWD" ];
        }
      ];
    }
  ];

  
  fonts = {
    fontDir.enable = true;

    fonts = with pkgs; [
      # icon fonts
      powerline-fonts
      material-design-icons
      font-awesome
      noto-fonts

      # nerdfonts
      (nerdfonts.override {
        fonts = [
          "JetBrainsMono"
        ];
      })
    ];

  };

  # dconf is a low-level configuration system.
  programs.dconf.enable = true;

  # The OpenSSH agent remembers private keys for you
  # so that you don’t have to type in passphrases every time you make an SSH connection. 
  # Use `ssh-add` to add a key to the agent.
  programs.ssh.startAgent = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    vscode
    firefox
    thunderbird
    pinentry-curses
    pinentry-qt
    paperkey
    ansible
  ];

  # PipeWire is a new low-level multimedia framework.
  # It aims to offer capture and playback for both audio and video with minimal latency.
  # It support for PulseAudio-, JACK-, ALSA- and GStreamer-based applications. 
  # PipeWire has a great bluetooth support, it can be a good alternative to PulseAudio.
  #     https://nixos.wiki/wiki/PipeWire
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    # jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };
  # rtkit is optional but recommended
  security.rtkit.enable = true;
  # Remove sound.enable or turn it off if you had it set previously, it seems to cause conflicts with pipewire
  sound.enable = false;
  # Disable pulseaudio, it conflicts with pipewire too.
  hardware.pulseaudio.enable = false;

  # enable bluetooth & gui paring tools - blueman
  # or you can use cli:
  # $ bluetoothctl
  # [bluetooth] # power on
  # [bluetooth] # agent on
  # [bluetooth] # default-agent
  # [bluetooth] # scan on
  # ...put device in pairing mode and wait [hex-address] to appear here...
  # [bluetooth] # pair [hex-address]
  # [bluetooth] # connect [hex-address]
  # Bluetooth devices automatically connect with bluetoothctl as well:
  # [bluetooth] # trust [hex-address]
  hardware.bluetooth.enable = true;
  services.blueman.enable = true;

  # https://flatpak.org/setup/NixOS
  services.flatpak.enable = true;

  # security with polkit
  services.power-profiles-daemon = {
    enable = true;
  };
  security.polkit.enable = true;
  # security with gnome-kering
  services.gnome.gnome-keyring.enable = true;
  security.pam.services.greetd.enableGnomeKeyring = true;

  services = {
    dbus.packages = [ pkgs.gcr ];

    geoclue2.enable = true;

    udev.packages = with pkgs; [
      gnome.gnome-settings-daemon
      yubikey-personalization
    ];
  };

  services.fwupd.enable = true;
  services.pcscd.enable = true;

  # add user's shell into /etc/shells
  environment.shells = with pkgs; [
    bash
    zsh
  ];
  # set user's default shell system-wide
  users.defaultUserShell = pkgs.zsh;

  programs.zsh = {
    enable = true;
  };
}