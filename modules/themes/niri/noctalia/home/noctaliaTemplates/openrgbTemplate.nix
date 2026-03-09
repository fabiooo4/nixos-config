{
  pkgs,
  lib,
  config,
  osConfig,
  themeName,
  ...
}: {
  config = let
    enabled = osConfig.theme.active == themeName && osConfig.systemSettings.rgb.enable;

    templatePath = pkgs.writeText "openrgbTemplate.sh" ''
      #!/bin/bash
      ${pkgs.openrgb}/bin/openrgb --color {{colors.on_primary.default.hex_stripped}} --brightness 100
    '';

    outputPath = "${config.xdg.configHome}/OpenRGB/noctaliaTemplate.sh";

    postHook = "bash ${outputPath}";
  in
    lib.mkIf enabled
    {
      theme.${themeName}.templates.openrgb = {
        inputPath = templatePath;
        outputPath = outputPath;
        postHook = postHook;
      };
    };
}
