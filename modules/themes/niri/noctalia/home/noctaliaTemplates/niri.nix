{
  config,
  lib,
  ...
}: {
  config = {
    programs.noctalia-shell.settings.templates.activeTemplates = [
      {
        id = "niri";
        active = true;
      }
    ];

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
