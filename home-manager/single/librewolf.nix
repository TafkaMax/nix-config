{ pkgs, lib, config, ...}:
{
  programs.librewolf = {
    enable = true;
    settings = {
      # enable firefox-sync
      "identity.fxaccounts.enabled" = true;
      "services.sync.username" = "firefox@e1ectron.de"; 
      # only booksmarks and addons should be synced
      "services.sync.engine.addresses" = false;
      "services.sync.engine.history" = false;
      "services.sync.engine.prefs" = false;
      "services.sync.engine.tabs" = false;
      "services.sync.engine.passwords" = false;
      "services.sync.engine.bookmarks" = true;
      "services.sync.engine.addons" = true;
      "services.sync.engine.creaditcards" = false;

      "browser.uidensity" = 1;
      "browser.warnOnQuit" = false;
      "browser.toolbars.bookmarks.visibility" = "never";
    };
  };
}
