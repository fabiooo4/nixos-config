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
          id = "discord";
          enabled = true;
        }
      ];

      programs.vesktop.vencord = {
        settings = {
          enabledThemes = ["noctalia.theme.css"];
        };
      };
    };
}
