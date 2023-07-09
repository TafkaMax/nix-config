{ config, lib, pkgs, ... }:
lib.mkIf config.setup.gui.enable { 
  
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  users.users.snd.packages = with pkgs; [

    # programming
    kotlin
    haskell.compiler.ghc94
    cmake
    android-tools
    android-studio
    gcc
    clang
    cargo
    clippy
    maven
    android-studio

    # everything else
    pdfarranger
    libreoffice
    (unstable.tor-browser-bundle-bin.override { useHardenedMalloc = false; })
    unstable.zfxtop
    jellyfin-media-player
    alacritty
    xournalpp
    fd
    gthumb
    dpkg
    zathura
    sshfs
    pinentry # small collection of dialog programs that allow GnuPG to read passphrases
    qemu
    qjournalctl
    deluge-gtk
    torrenttools
    virt-manager
    virt-viewer
    unzip
    qutebrowser
    monero-gui
    bitwarden
    gnome.seahorse
    miniserve
    texlive.combined.scheme-full
    ungoogled-chromium
    qalculate-gtk
    libqalculate
    networkmanagerapplet 
    fluffychat
    signal-desktop
    element-desktop-wayland
    unstable.anki
    filezilla
    nix-tree 
    nix-melt 
    nix-diff 
    nix-init 
    manix 
    nix-output-monitor
    
    # Wayland
    wev
    waybar
    sway-contrib.grimshot
    wdisplays
    wofi
    wl-clipboard
    unstable.swaynotificationcenter

    # X-Server / bspmw
    xorg.xrandr
    xorg.setxkbmap
    x11_ssh_askpass
    xorg.xev
    polybar
    sxhkd
    rofi
    xorg.xinit
    nitrogen
  ];
}
