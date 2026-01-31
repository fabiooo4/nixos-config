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
          active = true;
        }
      ];

      programs.kitty.extraConfig = ''
        include themes/noctalia.conf
      '';
    };
}
