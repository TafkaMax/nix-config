{ nixosConfig, config, lib, ... }:

lib.mkIf nixosConfig.setup.mail.enable {

  programs.thunderbird = {
    enable = true;
    settings = {
      "privacy.donottrackheader.enabled" = true;
    };
    profiles = {
      personal = {
        isDefault = true;
        settings = {
          "mail.spellcheck.inline" = false;
          "javascript.enabled" = false;
        };
      };
    };
  };

  accounts = {
    email = {
      maildirBasePath = "/home/snd/mail";
      accounts = {
        "mailbox" = {
          primary = true;
          address = "${nixosConfig.secrets.email.mailbox.address}";
          userName = "${nixosConfig.secrets.email.mailbox.userName}";
          realName = "${nixosConfig.secrets.email.mailbox.realName}";
          imap = {
            host = "imap.mailbox.org";
            tls.useStartTls = true;
          };
          smtp = {
            host = "smtp.mailbox.org";
            port = 587;
            tls.useStartTls = true;
          };
          thunderbird = {
            enable = true;
            profiles = [ "personal" ];
          };
        };
        "tu-dresden" = { 
          primary = false;
          address = "${nixosConfig.secrets.email.tuDresden.address}";
          userName = "${nixosConfig.secrets.email.tuDresden.userName}";
          realName = "${nixosConfig.secrets.email.tuDresden.realName}"; 
          imap = {
            host = "msx.tu-dresden.de";
            tls.useStartTls = true;
          };
          smtp = {
            host = "msx.tu-dresden.de";
            port = 587;
            tls.useStartTls = true;
          };
          thunderbird = {
            enable = true;
            profiles = [ "personal" ];
          };
        };
      };
    };
  };
}
