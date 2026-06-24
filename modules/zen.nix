{
  environment.shellAliases.zen-browser = "zen";

  environment.etc."zen/policies/policies.json".text = builtins.toJSON {
    policies = {
      Homepage = {
        URL = "https://google.fr";
        StartPage = "homepage";
      };
      DefaultSearchProviderEnabled = true;
      DefaultSearchProviderName = "Google";
      DefaultSearchProviderSearchURL = "https://www.google.com/search?q={searchTerms}";
      RequestedLocales = [ "fr" ];
      Preferences = {
        "browser.tabs.closeButtons" = {
          Value = 1;
          Status = "default";
        };
      };
      ExtensionSettings = {
        "uBlock0@raymondhill.net" = {
          installation_mode = "force_installed";
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi";
        };
      };
    };
  };
}
