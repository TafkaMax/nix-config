{ pkgs, lib, ... }:

pkgs.fetchFromGitHub {
  owner = "datguypiko";
  repo = "Firefox-Mod-Blur";
  rev = "862997246204d946cd768fc3b036daff8e505003";
  sha256 = "sha256-oPXsHswAAJcP4j1PNZ7kjqa5ixfYJkid/qVk2YA1DRk=";
  name = "firefox-mod-blur";
}
