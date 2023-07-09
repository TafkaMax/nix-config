{ lib, stdenv, fetchgit }:
stdenv.mkDerivation rec {
    name = "grafanaDashboardsConfig";
  
    src = fetchgit { 
        url = "https://codeberg.org/snd/grafana_dashboards.git";
        rev = "fd9781c7024b1ad559f257a7394d6f63fe389e50";
        sha256 = "sha256-o0AHjuwavLUbEhBL1EFajppuOSexPaGfhTYmN9T580U=";
    };
  
    dontBuild = true;
    configurePhase = ''mkdir -p $out'';
    installPhase = ''
        cp -r dashboards/* $out/
    '';
}

