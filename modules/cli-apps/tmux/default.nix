{ options, config, lib, pkgs, ... }:

with lib;
with lib.internal;
let
  cfg = config.nixos-snowfall.cli-apps.tmux;
  configFiles = lib.snowfall.fs.get-files ./config;

  # Extrakto with wl-clipboard patched in.
  extrakto = pkgs.tmuxPlugins.mkTmuxPlugin {
    pluginName = "extrakto";
    version = "unstable-2021-04-04-wayland";
    src = pkgs.fetchFromGitHub {
      owner = "laktak";
      repo = "extrakto";
      rev = "efca89800293cbb8224463d82eeecffdb2f7036a";
      sha256 = "0000000000000000000000000000000000000000000000000000";
    };
    nativeBuildInputs = [ pkgs.makeWrapper ];
    postInstall = ''
      for f in extrakto.sh open.sh tmux-extrakto.sh; do
        wrapProgram $target/scripts/$f \
          --prefix PATH : ${with pkgs; lib.makeBinPath (
          [ pkgs.fzf pkgs.python3 pkgs.xclip wl-clipboard ]
          )}
      done
    '';
    meta = {
      homepage = "https://github.com/laktak/extrakto";
      description = "Fuzzy find your text with fzf instead of selecting it by hand ";
      license = lib.licenses.mit;
      platforms = lib.platforms.unix;
    };
  };

  plugins =
    [ extrakto ] ++
    (with pkgs.tmuxPlugins; [
      continuum
      nord
      tilish
      tmux-fzf
      vim-tmux-navigator
    ]);
in
{
  options.nixos-snowfall.cli-apps.tmux = with types; {
    enable = mkBoolOpt false "Whether or not to enable tmux.";
  };

  config = mkIf cfg.enable {
    nixos-snowfall.home.extraOptions = {
      programs.tmux = {
        enable = true;
        terminal = "screen-256color-bce";
        clock24 = true;
        historyLimit = 2000;
        keyMode = "vi";
        newSession = true;
        extraConfig = builtins.concatStringsSep "\n"
          (builtins.map lib.strings.fileContents configFiles);

        inherit plugins;
      };
    };
  };
}
