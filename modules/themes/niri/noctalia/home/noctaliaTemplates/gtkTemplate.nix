{
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
      programs.noctalia-shell.settings.templates.activeTemplates = [
        {
          id = "gtk";
          enabled = true;
        }
      ];

      gtk = {
        enable = true;
        gtk3 = {
          enable = true;
          extraCss = "@import './noctalia.css'";
          colorScheme = "dark";
        };
        gtk4 = {
          enable = true;
          extraCss = "@import './noctalia.css'";
          colorScheme = "dark";
        };
      };
    };
}
