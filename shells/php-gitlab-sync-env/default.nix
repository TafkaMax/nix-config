
{
  # Snowfall Lib provides a customized `lib` instance with access to your flake's library
  # as well as the libraries available from your flake's inputs.
  lib,
  # You also have access to your flake's inputs.
  inputs,
  # All other arguments come from NixPkgs. You can use `pkgs` to pull shells or helpers
  # programmatically or you may add the named attributes as arguments here.
  pkgs,
  stdenv,
  ...
}:
let
  phpEnv = pkgs.php82.buildEnv {
    extensions = { enabled, all}: enabled ++ (with all; [ xsl ]);
    extraConfig = "memory_limit=-1";
  };
in
pkgs.mkShell {
  # Create your shell
  #LD_LIBRARY_PATH = lib.makeLibraryPath [ pkgs.stdenv.cc.cc ];
  #LD_LIBRARY_PATH = "$LD_LIBRARY_PATH:${pkgs.stdenv.cc.cc.lib}/lib";
  packages = with pkgs; [
    phpEnv
    phpEnv.packages.composer
  ];
  buildInputs = with pkgs; [
    phpEnv
    phpEnv.packages.composer
  ];
#nativeBuildInputs = with pkgs; [
#    stdenv.cc.cc.lib
#  ];
}
