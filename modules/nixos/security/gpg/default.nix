{
  config,
  pkgs,
  lib,
  namespace,
  inputs,
  ...
}:

with lib;
with lib.${namespace};
let
  cfg = config.${namespace}.security.gpg;

  gpgConf = "${inputs.gpg-base-conf}/gpg.conf";

  gpgAgentConf = ''
    enable-ssh-support
    default-cache-ttl 60
    max-cache-ttl 120
    pinentry-program ${pkgs.pinentry-gnome3}/bin/pinentry
  '';

  scdaemonConf = ''
    disable-ccid
  '';

  guide = "${inputs.yubikey-guide}/README.md";

  theme = pkgs.fetchFromGitHub {
    owner = "jez";
    repo = "pandoc-markdown-css-theme";
    rev = "019a4829242937761949274916022e9861ed0627";
    sha256 = "1h48yqffpaz437f3c9hfryf23r95rr319lrb3y79kxpxbc9hihxb";
  };

  guideHTML = pkgs.runCommand "yubikey-guide" { } ''
    ${pkgs.pandoc}/bin/pandoc \
      --standalone \
      --metadata title="Yubikey Guide" \
      --from markdown \
      --to html5+smart \
      --toc \
      --template ${theme}/template.html5 \
      --css ${theme}/docs/css/theme.css \
      --css ${theme}/docs/css/skylighting-solarized-theme.css \
      -o $out \
      ${guide}
  '';

  guideDesktopItem = pkgs.makeDesktopItem {
    name = "yubikey-guide";
    desktopName = "Yubikey Guide";
    genericName = "View Yubikey Guide in a web browser";
    exec = "${pkgs.xdg-utils}/bin/xdg-open ${guideHTML}";
    icon = ./yubico-icon.svg;
    categories = [ "System" ];
  };

  reload-yubikey = pkgs.writeShellScriptBin "reload-yubikey" ''
    ${pkgs.gnupg}/bin/gpg-connect-agent "scd serialno" "learn --force" /bye
  '';
in
{
  options.${namespace}.security.gpg = with types; {
    enable = mkBoolOpt false "Whether or not to enable GPG.";
    agentTimeout = mkOpt int 5 "The amount of time to wait before continuing with shell init.";
  };

  config = mkIf cfg.enable {
    services.pcscd.enable = true;
    services.udev.packages = with pkgs; [ yubikey-personalization ];
    #services.yubikey-agent.enable = true;

    environment.systemPackages = with pkgs; [
      cryptsetup
      paperkey
      gnupg
      pinentry-curses
      pinentry-gnome3
      pinentry-qt
      paperkey
      guideDesktopItem
      reload-yubikey
      yubioath-flutter
      age-plugin-yubikey
      libyubikey
      libfido2
    ];

    programs = {
      ssh.startAgent = false;

      gnupg.agent = {
        enable = true;
        enableSSHSupport = true;
        enableExtraSocket = true;
        pinentryPackage = pkgs.pinentry-gnome3;
      };

      yubikey-touch-detector.enable = true;
    };

    # Declarative chmod 700
    systemd.user.tmpfiles.rules = [
      "z %h/.gnupg 0700 - - -"
    ];

    ${namespace} = {
      home.file = {
        ".gnupg/.keep".text = "";

        ".gnupg/yubikey-guide.md".source = guide;
        ".gnupg/yubikey-guide.html".source = guideHTML;

        ".gnupg/gpg.conf".source = gpgConf;
        ".gnupg/gpg-agent.conf".text = gpgAgentConf;

        ".gnupg/scdaemon.conf".text = scdaemonConf;
      };
    };
  };
}
