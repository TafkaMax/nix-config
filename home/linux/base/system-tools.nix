{ pkgs, ... }:


{
  # Linux Only Packages, not available on Darwin
  home.packages = with pkgs; [
    btop # replacement of htop/nmon
    htop
    nmon
    iotop
    iftop

    # misc
    libnotify

    # system call monitoring
    strace # system call monitoring
    ltrace # library call monitoring
    lsof # list open files

    # system tools
    sysstat
    lm_sensors # for `sensors` command
    ethtool
    pciutils # lspci
    usbutils # lsusb
    hdparm # for disk performance, command 
    dmidecode # a tool that reads information about your system's hardware from the BIOS according to the SMBIOS/DMI standard
    smartmontools # check on disk health
  ];

  # auto mount usb drives
  services = {
    udiskie.enable = true;
  };

  services = {
    # TODO syncthing for file synchronization between devices, if needed.
    # syncthing.enable = true;
  };

}