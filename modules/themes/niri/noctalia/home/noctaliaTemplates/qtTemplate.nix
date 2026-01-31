{
  lib,
  pkgs,
  config,
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
          id = "qt";
          enabled = true;
        }
      ];

      home.packages = with pkgs; [
        qt6Packages.qt6ct
        libsForQt5.qt5ct
      ];

      qt = let
        settings = {
          Appearance = {
            color_scheme_path = "${config.home.homeDirectory}/.config/qt6ct/colors/noctalia.conf";
            custom_palette = true;
            style = "Fusion";
          };
        };
      in {
        enable = true;
        qt6ctSettings = settings;
        qt5ctSettings = settings;
      };

      systemd.user.sessionVariables = {
        QT_QPA_PLATFORM = "wayland";
        QT_QPA_PLATFORMTHEME = "qt6ct";
      };
    };
}
