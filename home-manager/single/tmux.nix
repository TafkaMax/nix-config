{ config, pkgs, ... }:
{
  programs.tmux = {
    enable = true;
    clock24 = true;
    aggressiveResize = true;
    baseIndex = 1;
    keyMode = "vi";
    sensibleOnTop = true;
    terminal = "tmux-256color";
    plugins = with pkgs.tmuxPlugins; [
      
      #{
      #  plugin = catppuccin;
      #  extraConfig = ''
      #    set -g @plugin 'catppuccin/tmux'
      #    set -g @catppuccin_flavour 'macchiato'
      #    set -g @catppuccin_powerline_icons_theme_enabled on 
      #    set -g @catppuccin_l_left_separator "" 
      #    set -g @catppuccin_l_right_separator "" 
      #    set -g @catppuccin_r_left_separator "" 
      #    set -g @catppuccin_r_right_separator "" 
      #''; 
      #}

    ];
    extraConfig = ''
      set -g mouse on
      set -g status off
    ''; 
  };
}
