{ config, pkgs, lib, ... }:
{

options = with lib; with lib.types; {
    setup.extraArch.enable = mkEnableOption "ExtraArch";
};   

config = {
  
    programs.dconf.enable = true; # required for virt-manager

    virtualisation = {
        libvirtd = {
            enable = config.setup.libvirt.enable;
            qemu = {
                package = pkgs.qemu;
                ovmf = {
                    enable = config.setup.libvirt.ovmf.enable;
                    packages = [ 
                        pkgs.OVMFFull.fd 
                        pkgs.pkgsCross.aarch64-multiplatform.OVMF.fd
                    ];
                };
            };
        };
        podman = {
            enable = config.setup.podman.enable;
        };
        oci-containers.backend = "podman";
    };

    # To disable libvirtd autostart
    systemd.services.libvirtd.enable = config.setup.libvirt.autostart.enable;

    boot.binfmt.emulatedSystems = lib.mkIf config.setup.extraArch.enable [ "aarch64-linux" ];

};

}
