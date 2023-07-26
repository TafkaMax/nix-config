{ options, config, pkgs, lib, inputs, ... }:

#TODO enable gpg if comfortable
with lib;
with lib.internal;
let
  cfg = config.nixos-snowfall.tools.git;
  #gpg = config.nixos-snowfall.security.gpg;
  user = config.nixos-snowfall.user;
in
{
  options.nixos-snowfall.tools.git = with types; {
    enable = mkBoolOpt false "Whether or not to install and configure git.";
    userName = mkOpt types.str user.fullName "The name to configure git with.";
    userEmail = mkOpt types.str user.email "The email to configure git with.";
    #signingKey = mkOpt types.str "9762169A1B35EA68" "The key ID to sign commits with.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ git ];


    nixos-snowfall.home.extraOptions = {
      # `programs.git` will generate the config file: ~/.config/git/config
      # to make git use this config file, `~/.gitconfig` should not exist!
      #
      #    https://git-scm.com/docs/git-config#Documentation/git-config.txt---global
      home.activation.removeExistingGitconfig = inputs.home-manager.lib.hm.dag.entryBefore [ "checkLinkTargets" ] ''
        rm -f ~/.gitconfig
      '';
      programs.git = {
        enable = true;
        inherit (cfg) userName userEmail;
        lfs = enabled;
        #signing = {
        #  key = cfg.signingKey;
        #  signByDefault = mkIf gpg.enable true;
        #};
        extraConfig = {
          init = { defaultBranch = "main"; };
          pull = { rebase = true; };
          push = { autoSetupRemote = true; };
          core = { whitespace = "trailing-space,space-before-tab"; };
          safe = {
            directory = "${config.users.users.${user.name}.home}/work/config";
          };
          delta = {
            enable = true;
            options = {
              features = "side-by-side";
            };
          };
          aliases = {
            # common aliases
            br = "branch";
            co = "checkout";
            st = "status";
            ls = "log --pretty=format:\"%C(yellow)%h%Cred%d\\\\ %Creset%s%Cblue\\\\ [%cn]\" --decorate";
            ll = "log --pretty=format:\"%C(yellow)%h%Cred%d\\\\ %Creset%s%Cblue\\\\ [%cn]\" --decorate --numstat";
            cm = "commit -m";
            ca = "commit -am";
            dc = "diff --cached";
            amend = "commit --amend -m";

            # aliases for submodule
            update = "submodule update --init --recursive";
            foreach = "submodule foreach";
          };
        };
      };
    };
  };
}
