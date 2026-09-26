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

    # Helper to call noctalia ipc commands as strings instead of lists of strings
    noctalia = cmd: ["noctalia" "msg"] ++ (pkgs.lib.splitString " " cmd);
  in
    lib.mkIf enabled
    {
      home.packages = [
        (pkgs.writeShellScriptBin
          "noctalia-diff"
          ''
            diff -u -U 100000 <(${pkgs.jq}/bin/jq -S . ${config.home.homeDirectory}/.config/noctalia/settings.json) <(${pkgs.wl-clipboard}/bin/wl-paste | ${pkgs.jq}/bin/jq -S .) | ${pkgs.delta}/bin/delta
          '')

        # Wrapped gnome-control-center
        (pkgs.symlinkJoin {
          name = "gnome-control-center-wrapped";
          paths = [pkgs.gnome-control-center];
          buildInputs = [pkgs.makeWrapper];
          postBuild = ''
            wrapProgram $out/bin/gnome-control-center \
              --set XDG_CURRENT_DESKTOP GNOME
          '';
        })
      ];

      systemd.user.sessionVariables = {
        # Fix for missing icons
        QT_QPA_PLATFORMTHEME = "gtk3";
      };

      # Noctalia niri keybinds
      programs.niri.settings.binds = {
        # Utilities ----------------------------------------
        "Mod+Space".action.spawn = noctalia "panel-toggle launcher";
        "Mod+C".action.spawn = noctalia "panel-toggle clipboard";
        "Mod+N".action.spawn = noctalia "notification-clear-active";

        # Audio controls
        "XF86AudioLowerVolume".action.spawn = noctalia "volume-down";
        "XF86AudioRaiseVolume".action.spawn = noctalia "volume-up";
        "XF86AudioMute".action.spawn = noctalia "volume-mute";
        "XF86AudioMicMute".action.spawn = noctalia "mic-volume-set 0";

        "XF86AudioPlay".action.spawn = noctalia "media playPause";
        "XF86AudioStop".action.spawn = noctalia "media stop";
        "XF86AudioPrev".action.spawn = noctalia "media previous";
        "XF86AudioNext".action.spawn = noctalia "media next";
        # Audio controls

        # Brightness controls
        "XF86MonBrightnessUp".action.spawn = noctalia "brightness-up";
        "XF86MonBrightnessDown".action.spawn = noctalia "brightness-down";
        # Brightness controls
        # Utilities ----------------------------------------
      };

      # To see the diff of current settings and the gui modified ones run:
      # nix shell nixpkgs#jq nixpkgs#colordiff nixpkgs#wl-clipboard -c bash -c "diff -u <(jq -S . ~/.config/noctalia/settings.json) <(wl-paste | jq -S .) | colordiff"
      programs.noctalia = {
        enable = true;

        # Activate calendar support
        package = inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default.overrideAttrs (oldAttrs: {
          # TODO: Remove when fixed
          nativeBuildInputs = (oldAttrs.nativeBuildInputs or []) ++ [pkgs.qt6.wrapQtAppsHook];

          # Dependencies for Wallcards noctalia plugin
          buildInputs =
            (oldAttrs.buildInputs or [])
            ++ [
              pkgs.unstable.qt6.qt5compat
              pkgs.unstable.qt6.qtsvg
            ];
        });

        settings =
          lib.recursiveUpdate
          (fromTOML (builtins.readFile ./noctalia-config.toml))
          {
            wallpaper = let
              path = "${config.home.homeDirectory}/Pictures/Wallpapers";
            in
              lib.optionalAttrs (builtins.pathExists path) {
                directory = path;
              };

            bar = {
              widgets.margin_ends = builtins.floor ((1920 / 2) * (1 - cfg.bar.percent));
            };

            idle.behavior = {
              lock.enabled = cfg.idle.enable;
              lock-and-suspend.enabled = cfg.idle.enable;
              screen-off.enabled = cfg.idle.enable;
            };
          };
      };
    };
}
