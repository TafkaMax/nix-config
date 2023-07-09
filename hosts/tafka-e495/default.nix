{ config, ... } @ args:

{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ../../modules/nixos/core-desktop.nix
		../../modules/nixos/gnome.nix
    ../../modules/nixos/user-group.nix
    #../../secrets
  ];

	# Change this value to point to a storage device where the root partition will live.
	# eg. /dev/nvme0n1p2
	boot.initrd.luks.devices.crypt.device = "/dev/nvme0n1p2";
  
  networking = {
    hostName = "tafka-e495";
    networkmanager.enable = true;
    interfaces = {
    	enp2s0 = {
     		useDHCP = true;
     	};
     	wlp4s0 = {
     		useDHCP = true;
     	};
    };
  };


  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?

}


