{ ... }:
{
  imports = [
    ../server
    ./development.nix
    ./neovim.nix
    ./vscode.nix
    ./kitty.nix
  ];
}
