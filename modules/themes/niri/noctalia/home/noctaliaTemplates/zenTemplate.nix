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
          id = "zenBrowser";
          enabled = true;
        }
      ];

      programs.zen-browser.profiles.default.settings = {
        "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
      };
    };
}
