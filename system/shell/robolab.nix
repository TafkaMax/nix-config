{ pkgs ? import <nixpkgs> { } }:
let
  ev3dev = pkgs.python3Packages.buildPythonPackage rec {
    pname = "ev3dev";
    version = "1.0.0";

    src = pkgs.fetchFromGitHub {
      owner = "ev3dev";
      repo = "ev3dev-lang-python";
      rev = version;
      sha256 = "sha256-ZOCXaC+nJEpWiESJXuWo5C/GO3cm9c5fU/AGw/C4hRg=";
      fetchSubmodules = true;
    };

    postPatch = ''
      echo "${version}\n" > RELEASE-VERSION
    '';

    propagatedBuildInputs = with pkgs.python3Packages; [ pillow ];
  };
in
pkgs.mkShell {
  nativeBuildInputs = with pkgs; [
    (python3.withPackages (ps: with ps; [
      ev3dev
      paho-mqtt
    ]))
  ];
}


