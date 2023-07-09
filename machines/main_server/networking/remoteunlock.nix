{ config, lib, ... }:
{
    # unlock encrypted disk remotely
    boot.initrd = {
        network.enable = true;
        network.ssh = {
            enable = true;
            port = 22;
            hostKeys = [ "/home/snd/.nix-dots/machines/main_server/networking/boot/ssh_host_ed25519_key" ];
            authorizedKeys = config.users.users.snd.openssh.authorizedKeys.keys;
        };
    };
    
    boot.kernelParams = [
        # Important: the client needs a static ip as well
        # e.g. i added an NetworkManger profile with static ip 10.0.0.10 and gateway 10.0.0.1 that i activate when needed
        "ip=10.0.0.1::10.0.0.1:255.255.255.0:${config.networking.hostName}:lan0:off" 
    ];
}
