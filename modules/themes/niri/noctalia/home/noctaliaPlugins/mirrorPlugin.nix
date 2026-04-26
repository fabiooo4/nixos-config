{
  pkgs,
  lib,
  osConfig,
  themeName,
  ...
}: {
  config = let
    enabled = osConfig.theme.active == themeName;
  in
    lib.mkIf enabled
    {
      home.packages = with pkgs; [
        wl-mirror
      ];

      programs.noctalia-shell.plugins.states = {
        mirror-mirror = {
          enabled = true;
          sourceUrl = "https://github.com/noctalia-dev/noctalia-plugins";
        };
      };
    };
}
