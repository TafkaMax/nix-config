{ lib, stdenv, fetchgit }:
stdenv.mkDerivation rec {
  name = "adi1090x-plymouth";
  version = "0.0.1";
  
  src = fetchgit { 
    url = "https://github.com/adi1090x/plymouth-themes";
    sha256 = "sha256-VNGvA8ujwjpC2rTVZKrXni2GjfiZk7AgAn4ZB4Baj2k=";
  };
  
  dontBuild = true;
  configurePhase = ''mkdir -p $out/share/plymouth/themes/'';
  installPhase = ''
    cp -r pack_2/hexagon_dots_alt $out/share/plymouth/themes 
    cat pack_2/hexagon_dots_alt/hexagon_dots_alt.plymouth | \
    sed  "s@\/usr\/@$out\/@" > \
    $out/share/plymouth/themes/hexagon_dots_alt/hexagon_dots_alt.plymouth

    
    cp -r pack_1/abstract_ring $out/share/plymouth/themes 
    cat pack_1/abstract_ring/abstract_ring.plymouth | \
    sed  "s@\/usr\/@$out\/@" > \
    $out/share/plymouth/themes/abstract_ring/abstract_ring.plymouth
  '';
}

