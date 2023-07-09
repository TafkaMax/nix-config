{ config, ... }:

let
  #d = config.xdg.dataHome;
  #c = config.xdg.configHome;
  #cache = config.xdg.cacheHome;
in
rec {
  # add environment variables
  systemd.user.sessionVariables = {
    # clean up ~
    #LESSHISTFILE = cache + "/less/history";
    #LESSKEY = c + "/less/lesskey";
    #WINEPREFIX = d + "/wine";

    # set default applications
    BROWSER = "firefox";
    TERMINAL = "console";
    TERM = "xterm-256color";

    # enable scrolling in git diff
    DELTA_PAGER = "less -R";

    MANPAGER = "sh -c 'col -bx | bat -l man -p'";
  };

  home.sessionVariables = systemd.user.sessionVariables;
}