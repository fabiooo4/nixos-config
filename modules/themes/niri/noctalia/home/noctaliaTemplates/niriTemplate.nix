{
  lib,
  pkgs,
  osConfig,
  themeName,
  ...
}: {
  config = let
    cfg = osConfig.theme.${themeName};
    enabled = osConfig.theme.active == themeName;
  in
    lib.mkIf enabled
    {
      programs.noctalia-shell.settings.templates.activeTemplates = [
        {
          id = "niri";
          enabled = true;
        }
      ];

      # niri-flake does not support config includes yet
      # TODO: replace with proper config includes after https://github.com/sodiboo/niri-flake/pull/1548 merge
      xdg.configFile = (
        let
          # TODO: Remove when the blur pull request gets merged
          # https://github.com/niri-wm/niri/pull/3483
          blur-unstable =
            pkgs.writeText "blur-unstable.kdl"
            # kdl
            ''
              blur {
                  // off
                  passes 3
                  offset 4 
                  noise 0.02
                  saturation 1.5
              }

              // Applies blur
              window-rule {
                  match app-id="^kitty$"

                  background-effect {
                      blur true
                  }
              }

              // Applies blur and opacity
              window-rule {
                  match app-id="^sioyek$"

                  opacity 0.8
                  background-effect {
                      blur true
                  }
              }
            '';

          override = true;
          originalFileName = "niri-flake.kdl";
          filesToInclude = ["noctalia.kdl" blur-unstable];
          fixBorder = false;

          withOriginalConfig = dmsFiles:
            if override
            then [originalFileName] ++ dmsFiles
            else dmsFiles ++ [originalFileName];

          fixes = map (fix: "\n${fix}") (
            lib.optional fixBorder
            # kdl
            ''
              // Border fix
              // See https://yalter.github.io/niri/Configuration%3A-Include.html#border-special-case for details
              layout { border { on; }; }
            ''
          );
        in {
          niri-config.target = lib.mkForce "niri/${originalFileName}";
          niri-config-dms = {
            target = "niri/config.kdl";
            text = lib.pipe filesToInclude [
              (map (filename: "${filename}"))
              withOriginalConfig
              (map (filename: "include \"${filename}\""))
              (files: files ++ fixes)
              (builtins.concatStringsSep "\n")
            ];
          };
        }
      );
    };
}
