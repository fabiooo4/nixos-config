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
        qt6.qt5compat
        qt6.qtdeclarative
        qt6.qtsvg

        imagemagick
        ffmpeg
      ];

      programs.noctalia-shell.plugins.states = {
        wallcards = {
          enabled = true;
          sourceUrl = "https://github.com/noctalia-dev/noctalia-plugins";
        };
      };
    };
}
