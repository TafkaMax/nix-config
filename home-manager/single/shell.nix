{ nixosConfig, pkgs, lib, ... }:
let 
  z = nixosConfig.programs.zsh;
in
{
  
  # It might be necessary to remove the ~/.zshrc file if the build fails
  programs.zsh = {
    enable = z.enable;
    plugins = [
      {
        name = "zsh-nix-shell";
        file = "nix-shell.plugin.zsh";
        src = builtins.fetchTarball {
          url = "https://github.com/chisui/zsh-nix-shell/archive/refs/tags/v0.7.0.tar.gz";
          sha256 = "149zh2rm59blr2q458a5irkfh82y3dwdich60s9670kl3cl5h2m1";
        };
      }
    ];
  };
}
