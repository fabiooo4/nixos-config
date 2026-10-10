{
  pkgs,
  lib,
  config,
  osConfig,
  themeName,
  ...
}: {
  config = let
    enabled = osConfig.theme.active == themeName;
  in
    lib.mkIf enabled
    {
      programs.sioyek.config = {
        source = "${config.xdg.configHome}/sioyek/themes/noctalia.config";
      };
    };
}
