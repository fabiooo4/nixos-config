{
  lib,
  inputs,
  pkgs,
  config,
  osConfig,
  themeName,
  ...
}: {
  imports = [
    inputs.noctalia.homeModules.default
  ];

  config = let
    cfg = osConfig.theme.${themeName};
    enabled = osConfig.theme.active == themeName;

    # Helper to call noctalia-shell ipc commands as strings instead of lists of strings
    noctalia = cmd:
      [
        "noctalia-shell"
        "ipc"
        "call"
      ]
      ++ (pkgs.lib.splitString " " cmd);
  in
    lib.mkIf enabled
    {
      home.packages = [
        (pkgs.writeShellScriptBin
          "noctalia-diff"
          ''
            ${pkgs.delta}/bin/delta <(${pkgs.jq}/bin/jq -S . ${config.home.homeDirectory}/.config/noctalia/settings.json) <(${pkgs.wl-clipboard}/bin/wl-paste | ${pkgs.jq}/bin/jq -S .)
          '')
      ];

      systemd.user.sessionVariables = {
        # Fix for missing icons
        QT_QPA_PLATFORMTHEME = "gtk3";
      };

      # Noctalia niri keybinds
      programs.niri.settings.binds = {
        # Utilities ----------------------------------------
        "Mod+Space".action.spawn = noctalia "launcher toggle";
        "Mod+C".action.spawn = noctalia "launcher clipboard";
        "Mod+N".action.spawn = noctalia "notifications dismissAll";

        # Audio controls
        "XF86AudioLowerVolume".action.spawn = noctalia "volume decrease";
        "XF86AudioRaiseVolume".action.spawn = noctalia "volume increase";
        "XF86AudioMute".action.spawn = noctalia "volume muteOutput";
        "XF86AudioMicMute".action.spawn = noctalia "volume muteInput";

        "XF86AudioPlay".action.spawn = noctalia "media playPause";
        "XF86AudioStop".action.spawn = noctalia "media stop";
        "XF86AudioPrev".action.spawn = noctalia "media previous";
        "XF86AudioNext".action.spawn = noctalia "media next";
        # Audio controls

        # Brightness controls
        "XF86MonBrightnessUp".action.spawn = noctalia "brightness increase";
        "XF86MonBrightnessDown".action.spawn = noctalia "brightness decrease";
        # Brightness controls
        # Utilities ----------------------------------------
      };

      # To see the diff of current settings and the gui modified ones run:
      # nix shell nixpkgs#jq nixpkgs#colordiff nixpkgs#wl-clipboard -c bash -c "diff -u <(jq -S . ~/.config/noctalia/settings.json) <(wl-paste | jq -S .) | colordiff"
      programs.noctalia-shell = {
        enable = true;
        settings =
          lib.recursiveUpdate
          (import ./.noctalia-defaults.nix)
          {
            wallpaper = {
              overviewEnabled = true;
              directory = "${config.home.homeDirectory}/Pictures/Wallpapers"; # TODO: Check this path exists
              hideWallpaperFilenames = true;
            };

            general = {
              scaleRatio = cfg.interface.scaling;
              animationSpeed = 1.5;
              shadowDirection = "bottom";
            };

            ui = {
              panelBackgroundOpacity = 1;
            };

            # Dynamic colorscheme
            colorSchemes = {
              useWallpaperColors = true;
              generationMethod = "content"; # TODO: Make option
            };
            templates.enableUserTheming = true;

            bar = {
              backgroundOpacity = 1;
              density = cfg.bar.density;
              position = "left";
              showCapsule = false;
              widgets = {
                left = [
                  {
                    id = "Battery";
                    deviceNativePath = "BATT";
                    displayMode = "onhover";
                    hideIfIdle = false;
                    hideIfNotDetected = true;
                    showNoctaliaPerformance = true;
                    showPowerProfiles = true;
                    warningThreshold = 30;
                  }
                  {
                    id = "Clock";
                    customFont = "";
                    formatHorizontal = "HH:mm ddd, MMM dd";
                    formatVertical = "HH mm — dd MM";
                    tooltipFormat = "HH:mm ddd, MMM dd";
                    useCustomFont = false;
                    usePrimaryColor = false;
                  }
                  {
                    id = "MediaMini";
                    compactMode = false;
                    compactShowAlbumArt = true;
                    compactShowVisualizer = false;
                    hideMode = "hidden";
                    hideWhenIdle = false;
                    maxWidth = 145;
                    panelShowAlbumArt = true;
                    panelShowVisualizer = true;
                    scrollingMode = "hover";
                    showAlbumArt = true;
                    showArtistFirst = true;
                    showProgressRing = true;
                    showVisualizer = false;
                    useFixedWidth = false;
                    visualizerType = "linear";
                  }
                ];
                center = [
                  {
                    id = "Workspace";
                    characterCount = 2;
                    colorizeIcons = false;
                    enableScrollWheel = true;
                    followFocusedScreen = false;
                    groupedBorderOpacity = 1;
                    hideUnoccupied = false;
                    iconScale = 0.8;
                    labelMode = "index";
                    showApplications = false;
                    showLabelsOnlyWhenOccupied = true;
                    unfocusedIconsOpacity = 1;
                  }
                ];
                right = [
                  {
                    id = "Tray";
                    blacklist = [];
                    colorizeIcons = false;
                    drawerEnabled = true;
                    hidePassive = false;
                    pinned = [];
                  }
                  {
                    id = "NotificationHistory";
                    hideWhenZero = false;
                    hideWhenZeroUnread = false;
                    showUnreadBadge = true;
                  }
                  {
                    id = "Volume";
                    displayMode = "onhover";
                    middleClickCommand = "pwvucontrol || pavucontrol";
                  }
                  {
                    id = "Brightness";
                    displayMode = "onhover";
                  }
                  {
                    id = "ControlCenter";
                    colorizeDistroLogo = false;
                    colorizeSystemIcon = "primary";
                    customIconPath = "";
                    enableColorization = true;
                    icon = "noctalia";
                    useDistroLogo = true;
                  }
                ];
              };
            };

            dock.enabled = false;

            controlCenter = {
              shortcuts = {
                left = [
                  {id = "Network";}
                  {id = "Bluetooth";}
                  {id = "WallpaperSelector";}
                  {id = "Notifications";}
                ];
                right = [
                  {id = "NoctaliaPerformance";}
                  {id = "PowerProfile";}
                  {id = "KeepAwake";}
                  {id = "NightLight";}
                ];
              };
              cards = [
                {
                  id = "profile-card";
                  enabled = true;
                }
                {
                  id = "shortcuts-card";
                  enabled = true;
                }
                {
                  id = "media-sysmon-card";
                  enabled = true;
                }
                {
                  id = "weather-card";
                  enabled = true;
                }
                {
                  id = "audio-card";
                  enabled = false;
                }
                {
                  id = "brightness-card";
                  enabled = false;
                }
              ];
            };

            appLauncher = {
              enableClipboardHistory = true;
              terminalCommand = "kitty -e";
              viewMode = "grid";
            };

            notifications = {
              enabled = true;
              lowUrgencyDuration = 2;
              saveToHistory = {
                low = false;
                normal = true;
                critical = true;
              };
            };
          };
      };
    };
}
