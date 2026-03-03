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
        (pkgs.python3.withPackages (ps:
          with ps; [
            pygobject3
          ]))

        evolution-data-server
        libical
        gobject-introspection
      ];

      programs.noctalia-shell.plugins.states = {
        weekly-calendar = {
          enabled = true;
          sourceUrl = "https://github.com/noctalia-dev/noctalia-plugins";
        };
      };
    };
}
