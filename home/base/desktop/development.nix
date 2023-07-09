{  pkgs, nil, agenix, ... }:

{
  #############################################################
  #
  #  Basic settings for development environment
  # 
  #  Please avoid to install language specific packages here(globally),
  #  instead, install them independently using dev-templates:
  #     https://github.com/the-nix-way/dev-templates
  #
  #############################################################

  imports = [
    ./neovim.nix
  ];

  home.packages = with pkgs; [
    nil.packages."${pkgs.system}".default # nix language server
    agenix.packages."${pkgs.system}".default # agenix secret manager
    # cloud native
    docker-compose
    eksctl

    # DO NOT install build tools for C/C++, set it per project by devShell instead
    gnumake # used by this repo, to simplify the deployment
    clang-tools
    clang-analyzer



    # python
    (python310.withPackages (ps: with ps; [
      ipython
      requests
      pyquery
      pyyaml
    ]))

    # db related
    dbeaver

    # embedded development
    minicom
  ];

  programs = {

    direnv = {
      enable = true;
      nix-direnv.enable = true;

      enableZshIntegration = true;
      enableBashIntegration = true;
    };
  };
}