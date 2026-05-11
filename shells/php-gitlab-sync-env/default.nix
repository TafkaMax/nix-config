
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
  mkShell,
  ...
}:
let
  # 1. Initialize the old nixpkgs using the same system as the current pkgs
  pkgsOld = import inputs.nixpkgs-old {
    inherit (stdenv.hostPlatform) system;
    config = {
      allowUnfree = true;
      # If you need insecure packages from the old repo too:
      allowInsecurePredicate = pkg: builtins.elem (lib.getName pkg) [
        "php"
      ];
    };
  };
  phpEnv = pkgsOld.php81.buildEnv {
    extensions = { enabled, all}: enabled ++ (with all; [ xsl ]);
    extraConfig = "memory_limit=-1";
  };
in
mkShell {
  packages = with pkgs; [
    phpEnv
    phpEnv.packages.composer
  ];
  buildInputs = with pkgs; [
    phpEnv
    phpEnv.packages.composer
  ];
  shellHook = ''
    echo "PHP Dev Environment loaded."
    php -v
  '';
}
