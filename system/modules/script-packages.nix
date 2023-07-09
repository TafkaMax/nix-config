{ config, lib, pkgs, ... }:
let
  backupgpg = pkgs.writeShellScriptBin "backupgpg" ''
    gpg --armor --export > ~/pgp-public-keys.asc
    gpg --armor --export-secret-keys > ~/pgp-private-keys.asc
    gpg --export-ownertrust > ~/pgp-ownertrust.asc
  '';
  importgpg = pkgs.writeShellScriptBin "importgpg" ''
    gpg --import ~/pgp-public-keys.asc
    gpg --import --pinentry-mode loopback ~/pgp-private-keys.asc 
    gpg --import-ownertrust ~/pgp-ownertrust.asc
  ''; # the "--pinentry-mode loopback" makes shure that pinentry is not required
  removegpgfiles = pkgs.writeShellScriptBin "removegpgfiles" ''
    rm ~/pgp-public-keys.asc
    rm ~/pgp-private-keys.asc
    rm ~/pgp-ownertrust.asc
  '';
  copygpgfiles = pkgs.writeShellScriptBin "copygpgfiles" ''
    echo "IP"
    read serverip
    echo "user"
    read user
    backupgpg
    scp ~/pgp-public-keys.asc $user@$serverip:/home/$user
    scp ~/pgp-private-keys.asc $user@$serverip:/home/$user
    scp ~/pgp-ownertrust.asc $user@$serverip:/home/$user
    removegpgfiles
  '';
  bspwmx = pkgs.writeShellScriptBin "bspwmx" ''
    touch ~/.xinitrc && echo "exec bspwm" > ~/.xinitrc && startx
  '';
  flutter-set-android-sdk = pkgs.writeShellScriptBin "flutter-set-android-sdk" ''
    flutter config --android-sdk ~/.local/share/Android
  '';
  flutter-install-flutter-sdk = pkgs.writeShellScriptBin "flutter-install-flutter-sdk" ''
     cd ~/.local/share/ && git clone https://github.com/flutter/flutter.git -b stable && ~/.local/share/flutter/bin/flutter
  '';
  openmedia = pkgs.writeShellScriptBin "openmedia" ''
    mkdir -p /home/snd/sshfs-media && sshfs snd@10.0.0.1:/home/snd/media /home/snd/sshfs-media
  '';
  closemedia = pkgs.writeShellScriptBin "closemedia" ''
    umount /home/snd/sshfs-media && rm -r /home/snd/sshfs-media
  '';
  opennas = pkgs.writeShellScriptBin "opennas" ''
    mkdir -p /home/snd/nas && sshfs nas@10.0.0.1:/home/nas /home/snd/nas
  '';
  closenas = pkgs.writeShellScriptBin "closenas" ''
    umount /home/snd/nas && rm -r /home/snd/nas
  '';
  unlockremotedisk = pkgs.writeShellScriptBin "unlockremotedisk" ''
    echo "IP"
    read serverip
    echo "Password"
    read -s remote_password
    ssh -o StrictHostKeyChecking=no root@$serverip "echo $remote_password > /crypt-ramfs/passphrase"
  '';
  ncupload = pkgs.writeShellScriptBin "ncupload" ''
    if [ $(pwd | cut -d / -f -4) == "/home/snd/nextcloud" ]; then 
      rclone -v sync ./ nextcloud:/$(pwd | cut -d / -f 5-)/ ; 
    else 
      $(exit -1); 
    fi
  '';
  ncdownload = pkgs.writeShellScriptBin "ncdownload" ''
    if [ $(pwd | cut -d / -f -4) == "/home/snd/nextcloud" ]; then 
      rclone -v sync nextcloud:/$(pwd | cut -d / -f 5-)/ ./ ; 
    else 
      $(exit -1); 
    fi
  '';
  nccheckupload = pkgs.writeShellScriptBin "nccheckupload" ''
    if [ $(pwd | cut -d / -f -4) == "/home/snd/nextcloud" ]; then 
      rclone --dry-run -v sync ./ nextcloud:/$(pwd | cut -d / -f 5-)/ ; 
    else 
      $(exit -1); 
    fi
  '';
  nccheckdownload = pkgs.writeShellScriptBin "nccheckdownload" ''
    if [ $(pwd | cut -d / -f -4) == "/home/snd/nextcloud" ]; then 
      rclone --dry-run -v sync nextcloud:/$(pwd | cut -d / -f 5-)/ ./ ; 
    else 
      $(exit -1); 
    fi
  '';
in
lib.mkIf config.setup.gui.enable { 

  users.users.snd.packages = with pkgs; [
    unlockremotedisk
    openmedia
    closemedia
    closenas
    opennas
    ncupload
    nccheckupload
    ncdownload
    nccheckdownload
    bspwmx
    importgpg
    backupgpg
    removegpgfiles
    copygpgfiles
  ];
}
