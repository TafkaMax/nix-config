{ config, variables, ... }:

{

  imports = [
    # import base configuration for desktops (can be non linux)
    ../base/desktop
    
    # import linux specific base configuration
    ./base
    # import gnome specific configuration
    ./gnome
    # import desktop specific configuration
    ./desktop
  ];

  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home = {
    # TODO set username from variables.
    username = "tafka";
    homeDirectory = "/home/tafka";

    # This value determines the Home Manager release that your
    # configuration is compatible with. This helps avoid breakage
    # when a new Home Manager release introduces backwards
    # incompatible changes.
    #
    # You can update Home Manager without changing this value. See
    # the Home Manager release notes for a list of state version
    # changes in each release.
    stateVersion = "23.05";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}