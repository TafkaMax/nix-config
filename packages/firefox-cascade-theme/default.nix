{ pkgs, lib, ... }:

pkgs.fetchFromGitHub {
  owner = "andreasgrafen";
  repo = "cascade";
  rev = "a89173a67696a8bf43e8e2ac7ed93ba7903d7a70";
  sha256 = "sha256-D4ZZPm/li1Eoo1TmDS/lI2MAlgosNGOOk4qODqIaCes=";
  name = "firefox-cascade-theme";
}
