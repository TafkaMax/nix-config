{ pkgs, ... }:
{
  environment = {
    systemPackages = [ pkgs.kitty ];

    variables.TERMINAL = "kitty";

    # remove gnome-console if using another terminal.
    gnome.excludePackages = [ pkgs.gnome-console ];
  };
}
