{
  config,
  pkgs,
  inputs,
  lib,
  ...
}:
{
  imports = [ inputs.niri.homeModules.niri ];

  programs.niri = {
    enable = true;

    settings = {
      input.keyboard.xkb = {
        layout = "fr";
        variant = "";
      };

      outputs."DP-1" = {
        mode = {
          width = 3440;
          height = 1440;
          refresh = 120.000;
        };
        scale = 1.1;
      };

      layout.struts = {
        top = 56;
        bottom = 72;
        left = 0;
        right = 0;
      };

      spawn-at-startup = [
        {
          command = [
            "${lib.getExe inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default}"
          ];
        }
      ];
    };

    settings.binds = with config.lib.niri.actions; {
      "Mod+Shift+Slash".action = show-hotkey-overlay;
      "Mod+T".action = spawn "ghostty";
      "Mod+D".action = spawn "noctalia-shell" "ipc" "call" "launcher" "toggle";
          "Mod+L".action = spawn "noctalia-shell" "ipc" "call" "session" "lock";
          "Mod+Z".action = spawn "zen";
    };
  };
}
