{ pkgs, ... }:
let 
  nnnconf = ./../../home-manager/multi/nnn/nnn-script.sh;
in
{
  
  users.defaultUserShell = pkgs.zsh;

  programs.zsh = {
    enable = true;
    histSize = 10000;
    shellInit = ''
      source ${pkgs.agdsn-zsh-config}/etc/zsh/zshrc

      source ${nnnconf} 
      
      prompt off

      # starship
      eval "$(starship init zsh)"
    '';
    shellAliases = {
      l = "lsd -l";
      la = "lsd -la";
      ls = "lsd";
      lt = "tree";
    };
  };

  programs.starship = {
    enable = true;
    settings.add_newline = false;
  };

  environment.systemPackages  = with pkgs; [

    # file managers
    (nnn.override { withNerdIcons = true; })

    lsd
    tree
    starship
  ];

}
