{ pkgs, inputs, ... }:
{
  # ...

  home-manager.users.qt1 = {
    # ...
    programs.niri = {
      package = niri;
      settings = {
        # ...
        spawn-at-startup = [
          {
            command = [
              "noctalia-shell"
            ];
          }
        ];
      };
    };
  };
}
