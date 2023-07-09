{ nixosConfig, config, pkgs, ... }:
{
  programs.git = {
    enable = true;
    userName = "snd";
    userEmail = "${nixosConfig.secrets.git.email}";
    extraConfig = {
      init = {
        defaultBranch = "main";
      };
      commit = {
        gpgsign = true;
      };
      user = {
        signingkey = "41B716569B4A0F17AC8AD500067F5A2CDA2952D2";
      };
    };
    aliases = {
      psh = "push -u origin HEAD";
      pll = "pull origin HEAD";
      undo = "reset HEAD~";
      pub = "push -u origin";
    };
    delta = {
      enable = true;
      options = {
        line-numbers = "true";
        side-by-side = "true";
        features = "decorations";
        syntax-theme = "ansi";
        blame-code-style = "syntax";
        decorations = {
          commit-decoration-style = "bold yellow box ul";
          file-style = "bold yellow ul";
          file-decoration-style = "none";
        };
      };
    };
  };
}
