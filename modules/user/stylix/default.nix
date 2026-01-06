{
  config,
  lib,
  pkgs,
  inputs,
  osConfig,
  ...
} @ extraInputs: {
  options = {
    userSettings.stylix = {
      enable = lib.mkEnableOption "Enable stylix theming";
    };
  };

  # Cannot import home manager module if system module has already been imported
  imports = lib.optionals (!osConfig.stylix.enable) [inputs.stylix.homeModules.stylix];

  config = let
    stylixConf = config.userSettings.stylix;
  in
    lib.mkIf stylixConf.enable {
      stylix = {
        enable = config.userSettings.stylix.enable;
        targets.neovim.enable = false;
        targets.kitty.enable = false;

        polarity = "dark";
        base16Scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-dark-medium.yaml";

        image = extraInputs.userSettings.wallpaper;
        cursor = {
          package = extraInputs.userSettings.cursorPkg;
          name = extraInputs.userSettings.cursor;
          size = 24;
        };
        fonts = {
          monospace = {
            package = extraInputs.userSettings.fontPkg;
            name = extraInputs.userSettings.font;
          };
          serif = config.stylix.fonts.monospace;
          sansSerif = config.stylix.fonts.monospace;
        };
        iconTheme = {
          enable = true;
          package = pkgs.papirus-icon-theme;
          dark = "Papirus Dark";
          light = "Papirus Light";
        };
      };
    };
}
