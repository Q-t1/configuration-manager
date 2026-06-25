{ ... }:
{
  programs.firefox = {
    enable = true;
    profiles = {
      "Qt1" = {
        id = 0;
        isDefault = true;
        settings = {
          "browser.startup.homepage" = "https://google.fr";
          "browser.startup.page" = 1;
          "browser.toolbars.bookmarks.visibility" = "always";
        };
        bookmarks = {
          force = true;
          settings = [
            {
              toolbar = true;
              bookmarks = [
                {
                  name = "Nix Search";
                  url = "https://search.nixos.org/packages";
                }
              ];
            }
          ];
        };
      };
      "Popglace" = {
        id = 1;
        isDefault = false;
      };
    };
  };
}
