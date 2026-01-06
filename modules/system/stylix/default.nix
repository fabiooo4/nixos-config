{
  lib,
  config,
  pkgs,
  inputs,
  userSettings,
  ...
}: {
  options = {
    systemSettings.stylix = {
      enable = lib.mkEnableOption "Enable stylix theming";
    };
  };

  imports = [inputs.stylix.nixosModules.stylix];

  config = let
    stylixConf = config.systemSettings.stylix;
  in
    lib.mkIf stylixConf.enable {
      stylix = {
        enable = true;
        targets.chromium.enable = false;

        polarity = "dark";
        base16Scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-dark-medium.yaml";

        image = userSettings.wallpaper;
        cursor = {
          package = userSettings.cursorPkg;
          name = userSettings.cursor;
          size = 24;
        };
        fonts = {
          monospace = {
            package = userSettings.fontPkg;
            name = userSettings.font;
          };
          serif = config.stylix.fonts.monospace;
          sansSerif = config.stylix.fonts.monospace;
        };
      };
    };
}
