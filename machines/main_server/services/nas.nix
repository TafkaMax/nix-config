{ config, lib, ... }:
{
    users.users.nas =  {
        uid = 1001;
        home = "/home/nas";
        isNormalUser = true;
        description = "nas";
        createHome = true;
        openssh.authorizedKeys.keys = config.users.users.snd.openssh.authorizedKeys.keys; 
    };
}
