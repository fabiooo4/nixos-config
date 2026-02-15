{
  pkgs,
  lib,
  osConfig,
  config,
  themeName,
  ...
}: {
  options = {
    theme.${themeName}.templates = lib.mkOption {
      type = lib.types.attrsOf (lib.types.submodule ({name, ...}: {
        options = {
          inputPath = lib.mkOption {
            type = lib.types.either lib.types.str lib.types.path;
            description = "The path to the template file.";
            default = "${config.xdg.configHome}/noctalia/templates/${name}.nix";
          };

          outputPath = lib.mkOption {
            type = lib.types.str;
            description = "The path where the generated file should be placed.";
          };

          postHook = lib.mkOption {
            type = lib.types.nullOr lib.types.str;
            description = "A command to run after the template is generated.";
            default = null;
          };
        };
      }));
    };
  };

  config = let
    cfg = config.theme.${themeName};
    enabled = osConfig.theme.active == themeName;
  in
    lib.mkIf enabled
    {
      xdg.configFile."noctalia/user-templates.toml".source = pkgs.writeText "user-templates.toml" ''
        [config]

        [templates]
        ${lib.concatStrings (lib.mapAttrsToList (name: template: ''
            [templates.${name}]
            input_path = "${template.inputPath}"
            output_path = "${template.outputPath}"
            ${lib.optionalString (template.postHook != null) "post_hook = \"${template.postHook}\""}

          '')
          cfg.templates)}
      '';
    };
}
