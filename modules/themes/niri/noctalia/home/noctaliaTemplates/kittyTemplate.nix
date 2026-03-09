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
          id = "kitty";
          enabled = true;
        }
      ];

      programs.kitty.extraConfig = ''
        include themes/noctalia.conf
      '';
    };
}
