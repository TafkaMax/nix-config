{
  # Snowfall Lib provides a customized `lib` instance with access to your flake's library
  # as well as the libraries available from your flake's inputs.
  lib
, # You also have access to your flake's inputs.
  inputs
, # All other arguments come from NixPkgs. You can use `pkgs` to pull shells or helpers
  # programmatically or you may add the named attributes as arguments here.
  pkgs
, stdenv
, ...
}:

pkgs.mkShell {
  # Create your shell
  LD_LIBRARY_PATH = lib.makeLibraryPath [ pkgs.stdenv.cc.cc ];
  #LD_LIBRARY_PATH = "$LD_LIBRARY_PATH:${pkgs.stdenv.cc.cc.lib}/lib";
  packages = with pkgs; [
    python311
    python311Packages.pip
    poetry
  ];
  buildInputs = with pkgs; [
    python311
  ];
  nativeBuildInputs = with pkgs; [
    stdenv.cc.cc.lib
  ];
  shellHook = ''
    poetry install
    source $(poetry env info --path)/bin/activate
  '';
}
