{ pkgs, lib, ... }:

pkgs.fetchFromGitHub {
  owner = "datguypiko";
  repo = "Firefox-Mod-Blur";
  rev = "095d4536bc1f7e1432d67213e32996e28041d873";
  sha256 = "sha256-RQpOnpW68FnUN05jnh0RV5RnDr0GGpp084keAyfoiPY=";
  name = "firefox-mod-blur";
}
