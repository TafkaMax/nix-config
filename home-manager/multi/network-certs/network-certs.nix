{ pkgs, lib, ...}:

{
  home.file."tu-dresden-eduroam".source = ./tu-dresden-eduroam/rootcert.crt;
  home.file."tu-dresden-eduroam".target = ".config/network-certs/tu-dresden-eduroam/rootcert.crt";
}
