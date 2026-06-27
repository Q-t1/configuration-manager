{ pkgs, ... }:
{
  # Notification daemon
  services.mako = {
    enable = true;
    settings = {
      default-timeout = 5000;
    };
  };

  # Polkit authentication agent
  systemd.user.services.hyprpolkitagent = {
    Unit = {
      Description = "Hyprland Polkit Authentication Agent";
      PartOf = [ "graphical-session.target" ];
      After = [ "graphical-session.target" ];
      ConditionEnvironment = "WAYLAND_DISPLAY";
    };
    Service = {
      ExecStart = "${pkgs.hyprpolkitagent}/libexec/hyprpolkitagent";
      Slice = "session.slice";
      TimeoutStopSec = "5sec";
      Restart = "on-failure";
    };
    Install.WantedBy = [ "graphical-session.target" ];
  };

  # Idle daemon — lock after 5 min, screen off after 8 min
  services.hypridle = {
    enable = true;
    settings = {
      general = {
        lock_cmd = "dms ipc call lock lock";
        before_sleep_cmd = "dms ipc call lock lock";
        ignore_dbus_inhibit = false;
      };
      listener = [
        {
          timeout = 300;
          on-timeout = "dms ipc call lock lock";
        }
        {
          timeout = 480;
          on-timeout = "hyprctl dispatch dpms off";
          on-resume = "hyprctl dispatch dpms on";
        }
      ];
    };
  };
}
