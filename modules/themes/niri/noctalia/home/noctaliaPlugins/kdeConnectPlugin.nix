{
  pkgs,
  lib,
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
      programs.noctalia-shell.plugins.states = {
        kde-connect = {
          enabled = true;
          sourceUrl = "https://github.com/noctalia-dev/noctalia-plugins";
        };
      };
    };
}
