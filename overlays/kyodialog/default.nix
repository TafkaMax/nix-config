# Kyocera silently replaced the upstream tarball for 9.4-20240521 with a 10.1
# release at the same URL, breaking the nixpkgs package. Bump to 10.1 until
# nixpkgs is updated (this override will then fail with a hash mismatch).
{ ... }:
final: prev:
let
  bump = builtins.replaceStrings [ "9.4" ] [ "10.1" ];
in
{
  cups-kyodialog = prev.cups-kyodialog.overrideAttrs (old: {
    version = bump old.version;
    src = old.src.overrideAttrs {
      outputHash = "sha256-jJNTNcZiIcIkXZBEp+M012eaDbdAaa9YFUJ5msfWDy0=";
    };
    unpackCmd = bump old.unpackCmd;
    installPhase = bump old.installPhase;
  });
}
