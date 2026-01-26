{
  config,
  lib,
  inputs,
  ...
}: {
  imports = [
    inputs.niri.homeModules.niri
  ];

  config = {
    programs.niri = {
      enable = true;
      settings = {
        spawn-at-startup = [
          {
            command = [
              "noctalia-shell"
            ];
          }
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
        prefer-no-csd = false;

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

          "Mod+H".action = focus-column-left;
          "Mod+L".action = focus-column-right;
          "Mod+K".action = focus-workspace-up;
          "Mod+J".action = focus-workspace-down;

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
          # Workspace ----------------------------------------
        };
      };
    };

    # niri-flake does not support config includes yet
    # TODO: replace with proper config includes after https://github.com/sodiboo/niri-flake/pull/1548 merge
    xdg.configFile = (
      let
        override = true;
        originalFileName = "niri-flake";
        filesToInclude = ["noctalia"];
        enableBorder = false;

        withOriginalConfig = dmsFiles:
          if override
          then [originalFileName] ++ dmsFiles
          else dmsFiles ++ [originalFileName];

        fixes = map (fix: "\n${fix}") (
          lib.optional enableBorder
          # kdl
          ''
            // Border fix
            // See https://yalter.github.io/niri/Configuration%3A-Include.html#border-special-case for details
            layout { border { on; }; }
          ''
        );
      in {
        niri-config.target = lib.mkForce "niri/${originalFileName}.kdl";
        niri-config-dms = {
          target = "niri/config.kdl";
          text = lib.pipe filesToInclude [
            (map (filename: "${filename}"))
            withOriginalConfig
            (map (filename: "include \"${filename}.kdl\""))
            (files: files ++ fixes)
            (builtins.concatStringsSep "\n")
          ];
        };
      }
    );

    # Ensure the included file exists
    home.activation.createNiriColors = lib.hm.dag.entryAfter ["writeBoundary"] ''
      path="${config.home.homeDirectory}/.config/niri/noctalia.kdl"
      if [ ! -f "$path" ]; then
        touch "$path"
      fi
    '';
  };
}
