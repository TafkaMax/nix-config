{ nixosConfig, pkgs, lib, ...}:

{
  home.file."rclone".text = ''
[nextcloud]
type = webdav
url = https://nextcloud.pro7on.de/remote.php/webdav/
vendor = nextcloud
user = ${nixosConfig.secrets.rclone.nextcloud.user} 
pass = ${nixosConfig.secrets.rclone.nextcloud.pass} 
  '';
  home.file."rclone".target = ".config/rclone/rclone.conf";
}
