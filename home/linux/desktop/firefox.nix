{ nur, ... }:
{
  programs.firefox = {
    enable = true;
    profiles.default = {
      id = 0;
      name = "Default";
      isDefault = true;
      settings = {
        "browser.startup.homepage" = "about:blank";
        "browser.urlbar.placeholderName" = "Google";
      };
      extensions = with nur.repos.rycee.firefox-addons; [
        ublock-origin
      ];
    };
  };
}
