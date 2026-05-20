{
  lib,
  inputs,
  pkgs,
  stdenv,
  mkShell,
  ...
}:
let
  # Fallback to latest nodejs if nodejs_24 is not yet in your nixpkgs channel
  nodePkg = pkgs.nodejs_24 or pkgs.nodejs;
in
mkShell {
  packages = [
    nodePkg
    pkgs.yarn
    pkgs.git
    pkgs.curl
    pkgs.jq
    pkgs.nodePackages.corepack
  ];

  shellHook = ''
    echo "Node.js ${nodePkg.version} development environment loaded."
    node -v
    pnpm --version 2>/dev/null || true
    corepack --version 2>/dev/null || true
  '';
}
