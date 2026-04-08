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
        grim
        slurp
        wl-clipboard
        tesseract
        imagemagick
        zbar
        curl
        translate-shell
        wl-screenrec
        ffmpeg
        gifski
      ];

      programs.noctalia-shell.plugins.states = {
        screen-toolkit = {
          enabled = true;
          sourceUrl = "https://github.com/noctalia-dev/noctalia-plugins";
        };
      };
    };
}
