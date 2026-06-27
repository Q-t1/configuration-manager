{ pkgs, ... }:
{
  xdg.configFile."hypr/hyprland.lua" = {
    force = true;
    text = ''
    -- NVIDIA
    hl.env("LIBVA_DRIVER_NAME", "nvidia")
    hl.env("XDG_SESSION_TYPE", "wayland")
    hl.env("GBM_BACKEND", "nvidia-drm")
    hl.env("__GLX_VENDOR_LIBRARY_NAME", "nvidia")
    hl.env("NVD_BACKEND", "direct")
    hl.env("ELECTRON_OZONE_PLATFORM_HINT", "auto")

    -- Monitor
    hl.monitor({ output = "DP-1", mode = "3440x1440@120", position = "0x0", scale = 1.1 })

    -- Core config
    hl.config({
      general = {
        gaps_in     = 14,
        gaps_out    = 28,
        border_size = 2,
        layout      = "dwindle",
      },
      decoration = {
        rounding = 20,
      },
      animations = {
        enabled = true,
      },
      input = {
        kb_layout    = "fr",
        follow_mouse = 1,
      },
      misc = {
        vrr                      = 2,
        disable_hyprland_logo    = true,
        disable_splash_rendering = true,
      },
      dwindle = {
        preserve_split = true,
      },
      cursor = {
        no_hardware_cursors = true,
      },
    })

    -- Bezier curves
    hl.curve("easeOutCubic", { type = "bezier", points = { {0.33, 1},    {0.68, 1}    } })
    hl.curve("easeOutQuad",  { type = "bezier", points = { {0.25, 0.46}, {0.45, 0.94} } })
    hl.curve("mySpring",     { type = "spring", mass = 1, stiffness = 100, dampening = 12 })

    -- Animations
    hl.animation({ leaf = "windows",    enabled = true, speed = 4, spring = "mySpring",    style = "popin 80%" })
    hl.animation({ leaf = "windowsOut", enabled = true, speed = 3, bezier = "easeOutQuad", style = "popin 80%" })
    hl.animation({ leaf = "fade",       enabled = true, speed = 5, bezier = "default"      })
    hl.animation({ leaf = "workspaces", enabled = true, speed = 5, spring = "mySpring",    style = "slide" })

    -- Keybinds
    local super = "SUPER"

    hl.bind(super .. " + T", hl.dsp.exec_cmd("ghostty"))
    hl.bind(super .. " + D", hl.dsp.exec_cmd("dms ipc call spotlight toggle"))
    hl.bind(super .. " + L", hl.dsp.exec_cmd("dms ipc call lock lock"))
    hl.bind(super .. " + F", hl.dsp.exec_cmd("firefox"))
    hl.bind(super .. " + Q", hl.dsp.window.close())
    hl.bind(super .. " + V", hl.dsp.window.float({ action = "toggle" }))
    hl.bind(super .. " + M", hl.dsp.window.fullscreen())
    hl.bind(super .. " + left",  hl.dsp.focus({ direction = "left"  }))
    hl.bind(super .. " + right", hl.dsp.focus({ direction = "right" }))
    hl.bind(super .. " + up",    hl.dsp.focus({ direction = "up"    }))
    hl.bind(super .. " + down",  hl.dsp.focus({ direction = "down"  }))

    for i = 1, 9 do
      local key = tostring(i)
      hl.bind(super .. " + " .. key,         hl.dsp.focus({ workspace = i }))
      hl.bind(super .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
    end
    hl.bind(super .. " + 0",         hl.dsp.focus({ workspace = 10 }))
    hl.bind(super .. " + SHIFT + 0", hl.dsp.window.move({ workspace = 10 }))

    -- Mouse binds (replaces old bindm)
    hl.bind(super .. " + mouse:272", hl.dsp.window.drag(),   { mouse = true })
    hl.bind(super .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

    -- Window rules
    hl.window_rule({
      name     = "float-dialogs",
      match    = { title = "^(Open|Save|Save As|Open File|Choose File|Select File|File Upload|Preferences|Settings)$" },
      float = true,
    })
    hl.window_rule({
      name     = "float-java",
      match    = { class = "^(sun-awt-X11|java-lang-Thread)$" },
      float = true,
    })
    hl.window_rule({
      name       = "fullscreen-steam-games",
      match      = { class = "^steam_app_" },
      fullscreen = true,
      immediate  = true,
    })
    hl.window_rule({
      name      = "immediate-steam",
      match     = { class = "^(steam|Steam)$" },
      immediate = true,
    })

    -- Activate the systemd graphical session so DMS and other user
    -- services start (WantedBy = graphical-session.target).
    hl.on("hyprland.start", function()
      hl.exec_cmd("${pkgs.dbus}/bin/dbus-update-activation-environment --systemd DISPLAY HYPRLAND_INSTANCE_SIGNATURE WAYLAND_DISPLAY XDG_CURRENT_DESKTOP XDG_SESSION_TYPE && systemctl --user stop hyprland-session.target && systemctl --user start hyprland-session.target")
    end)
  '';
  };
}
