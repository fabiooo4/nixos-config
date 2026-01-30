{
  pkgs,
  config,
  inputs,
  lib,
  ...
}: {
  imports = [
    inputs.niri.homeModules.niri
  ];

  config = {
    # X11 app support
    home.packages = [pkgs.xwayland-satellite];

    programs.niri = {
      enable = true;
      settings = {
        spawn-at-startup = [
          {command = ["noctalia-shell"];}
          {command = ["xwayland-satellite"];}
        ];

        window-rules = [
          {
            geometry-corner-radius = let
              radius = 20.0;
            in {
              top-left = radius;
              top-right = radius;
              bottom-left = radius;
              bottom-right = radius;
            };
            clip-to-geometry = true;
          }
        ];

        layout = {
          focus-ring = {
            enable = true;
            width = 4;
          };
        };

        # Remove window decorations
        prefer-no-csd = true;

        debug = {
          # Allows notification actions and window activation from Noctalia.
          honor-xdg-activation-with-invalid-serial = [];
        };

        # Set overview bg to blurred wallpaper
        layer-rules = [
          {
            matches = [
              {
                namespace = "^noctalia-overview*";
              }
            ];
            place-within-backdrop = true;
          }
        ];

        hotkey-overlay.skip-at-startup = true;

        input = {
          mod-key = "Super";
        };

        binds = with config.lib.niri.actions; {
          # Workspace ----------------------------------------
          "Mod+O".action = toggle-overview;

          # TODO: Merge from options
          "Ctrl+Shift+Backslash".action = toggle-overview;

          "Mod+H".action = focus-column-left;
          "Mod+L".action = focus-column-right;
          "Mod+K".action = focus-window-or-workspace-up;
          "Mod+J".action = focus-window-or-workspace-down;

          "Mod+WheelScrollRight".action = focus-column-right;
          "Mod+WheelScrollLeft".action = focus-column-left;
          "Mod+WheelScrollDown" = {
            cooldown-ms = 150;
            action.focus-workspace-down = [];
          };
          "Mod+WheelScrollUp" = {
            cooldown-ms = 150;
            action.focus-workspace-up = [];
          };

          "Mod+Shift+WheelScrollDown" = {
            cooldown-ms = 150;
            action.focus-column-right = [];
          };
          "Mod+Shift+WheelScrollUp" = {
            cooldown-ms = 150;
            action.focus-column-left = [];
          };
          # Workspace ----------------------------------------

          # Window management --------------------------------
          "Mod+Q".action = close-window;

          "Mod+Shift+H".action = move-column-left;
          "Mod+Shift+L".action = move-column-right;
          "Mod+Shift+K".action = move-window-up-or-to-workspace-up;
          "Mod+Shift+J".action = move-window-down-or-to-workspace-down;

          "Mod+Return".action = maximize-column;
          "Mod+Ctrl+Return".action = fullscreen-window;
          # Not yet implemented in the flake
          # Activate when this is closed: https://github.com/sodiboo/niri-flake/issues/1493
          # "Mod+Shift+Return".action = maximize-window-to-edges;

          "Mod+Backslash".action = center-window;
          "Mod+Shift+Backslash".action = expand-column-to-available-width;
          "Mod+Ctrl+Backslash".action = center-visible-columns;

          "Mod+Alt+H".action = consume-or-expel-window-left;
          "Mod+Alt+L".action = consume-or-expel-window-right;

          "Mod+Minus".action.set-column-width = "-10%";
          "Mod+Equal".action.set-column-width = "+10%";
          "Mod+Shift+Minus".action.set-window-height = "-10%";
          "Mod+Shift+Equal".action.set-window-height = "+10%";

          "Mod+BracketRight".action = switch-preset-column-width;
          "Mod+BracketLeft".action = switch-preset-column-width-back;

          "Mod+Z".action = toggle-column-tabbed-display;

          "Mod+F".action = toggle-window-floating;
          "Mod+Shift+F".action = switch-focus-between-floating-and-tiling;
          # Window management --------------------------------

          # Utilities ----------------------------------------
          "Print".action.screenshot = [];
          "Shift+Print".action.screenshot-window = [];
          "Ctrl+Print".action.screenshot-screen = [];

          "Mod+Escape" = {
            allow-inhibiting = false;
            action = toggle-keyboard-shortcuts-inhibit;
          };

          # Audio controls
          # Handled by noctalia ipc calls
          "XF86AudioRaiseVolume" = lib.mkDefault {
            allow-when-locked = true;
            action.spawn-sh = "wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.1+ -l 1.0";
          };
          "XF86AudioLowerVolume" = lib.mkDefault {
            allow-when-locked = true;
            action.spawn-sh = "wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.1-";
          };
          "XF86AudioMute" = lib.mkDefault {
            allow-when-locked = true;
            action.spawn-sh = "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
          };
          "XF86AudioMicMute" = lib.mkDefault {
            allow-when-locked = true;
            action.spawn-sh = "wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle";
          };

          "XF86AudioPlay" = lib.mkDefault {
            allow-when-locked = true;
            action.spawn-sh = "playerctl play-pause";
          };
          "XF86AudioStop" = lib.mkDefault {
            allow-when-locked = true;
            action.spawn-sh = "playerctl stop";
          };
          "XF86AudioPrev" = lib.mkDefault {
            allow-when-locked = true;
            action.spawn-sh = "playerctl previous";
          };
          "XF86AudioNext" = lib.mkDefault {
            allow-when-locked = true;
            action.spawn-sh = "playerctl next";
          };
          # Audio controls

          # Brightness controls
          # Handled by noctalia ipc calls
          "XF86MonBrightnessUp" = lib.mkDefault {
            allow-when-locked = true;
            action.spawn = ["brightnessctl" "--class=backlight" "set" "+10%"];
          };
          "XF86MonBrightnessDown" = lib.mkDefault {
            allow-when-locked = true;
            action.spawn = ["brightnessctl" "--class=backlight" "set" "10%-"];
          };
          # Brightness controls

          # Utilities ----------------------------------------
        };
      };
    };
  };
}
