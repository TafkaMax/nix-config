{ pkgs, lib, ...}:
{

  programs.nnn = { 
    enable = true;
    package = pkgs.nnn.override ({ withNerdIcons = true; });
    plugins = {
      src = (pkgs.fetchFromGitHub {
        owner = "jarun";
        repo = "nnn";
        rev = "v4.8";
        sha256 = "sha256-QbKW2wjhUNej3zoX18LdeUHqjNLYhEKyvPH2MXzp/iQ=";
      }) + "/plugins";
      mappings = {
        p = "preview-tui";
      };
    };
    extraPackages = with pkgs; [ 
      less
      tree
      file
      mktemp
      unzip
      gnutar
      man
      libarchive # contains bsdtar
      viu
      ffmpegthumbnailer
      ffmpeg
      libreoffice
      poppler
      fontpreview
      djvulibre
      glow
      lynx
    ];
  };

}
