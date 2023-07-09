{ config, lib, ... }:
let 
    keys = [
    
    # Thinkpad
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCJhojJxNyX+0iuNSbZwpGJ78f4EqbFOElO2dNXTrxRtko0R6odtX4pOnxEeX+s9EE/YSoPbrWdhMT9innQPCyJ5Yp0aFz+qO1kB11Qy0lD9W26I11LrZ7MEBmJLjjAztHRoFbWaIZ538qJsWzPpb2npMejrKQfCmr4vGBhi/1jevwn0kyD2i2mKm4kKuuUqDEWb8H4mmHj3a4RZL/TsYsuFDQB6Wk0e1l2CEz9xdGHDAeaJkZdI6Sevv7h7p+fLyHAkA39vj/41MszcpYY4f93tfDOIpNvTHWTAt6tpAG66TSt9F1H9YMj1UmUPEifWl9lxHOgXHdE3OzJW/6t/YF1u2qeG3FMNJ8xl3xbJJ1ESU0TrbSxBsxBZsHZ+nk3mIz+HjwwoM9iMZ1x9Xs9IBSir5vwValU2mw+KnF2CMxn7tG1MVM/7yyC+LyQqmK00Y+XmlwrfTe/KYW/cwLfYblQDiJ1trjD2cuapkXBjWbyf8Pj/5b2Dv3v1Si3A7HR/xs= snd@nixos" 

    # Desktop
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCuurUIhTJKgqNQhDb+fdPYPqQRina/aKtSVbeYtP7F0Ymbg3VUTFE7Ka8CkpbiuUvQhUdZL78LvO9HGldXZSqVzU5xEqeR18gXvbJAT0XC3lvpxA4v3Q5YLbGeNbPS7nCIQDQSlA3p60wdAquj7WRg7CHRjUAQxSqHbfWT0H6Xqdc4/Wh9MBulpqjELJnhPpp0wwtfTN4CmLUEXagTi1MEj7T8BSa4GLNWhvkhVmp8jJD8WxOCTQ8OkDMUvvTHVtVkinVonbOz4JCzS8uCxtp70LuhlQqzOL5Cx26EhD3JQ7yrVJLyxWpZp76eAJBVONFM3RLeO7FvvlehyBNYV56ATN4ZmOVfu9NN/iYrdSOM1eqxzGpewzs45mBifQuAL22elRVunO2Kyxw8MSlfSJ/OCptGmTqwzg8Vk+ZwCJwI6yZ0q+qNmXT6P/gJs0OHXxKWrecq5RqCR+9f6dtRHN5eWZZ6T+RpnzwABzgpkJAqHD38D8zRq0XVlZ1g7jOVDGc= snd@nixos"
    ];
in
{
    users.users.snd.openssh.authorizedKeys.keys = keys;
    
    services.openssh = {
        enable = true;
        openFirewall = false; # if set to true, openssh will listen on every interface
        # password authentication should only be possible on the lan interface
        settings = {
          PermitRootLogin = "yes";
          PasswordAuthentication = false;
        };
        # because the following config doesn't archive what it suppost to do
        # i decided to only allow key authentication
        #extraConfig = ''
        #  PasswordAuthentication no
        #  ChallengeResponseAuthentication no

        #  Match Address 10.0.0.0/24
        #      PasswordAuthentication yes
        #'';
    };
}
