{ pkgs, lib, ... }:

pkgs.fetchFromGitHub {
  owner = "datguypiko";
  repo = "Firefox-Mod-Blur";
  rev = "6cd15ad2ebd710a9228439c6e2fc0d059633abb6";
  sha256 = "sha256-RQpOnpW68FnUN05jnh0RV5RnDr0GGpp084keAyfoiPY=";
  name = "firefox-mod-blur";
}
