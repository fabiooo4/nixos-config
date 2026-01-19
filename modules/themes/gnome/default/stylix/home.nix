{
  config,
  lib,
  inputs,
  osConfig,
  themeName,
  ...
}: {
  # Cannot import home manager module if system module has already been imported
  imports = lib.optionals (!osConfig.theme.${themeName}.stylix.enable) [inputs.stylix.homeModules.stylix];

  config = let
    cfg = osConfig.theme.${themeName}.stylix;
  in
    lib.mkIf cfg.enable {
      qt = {
        enable = true;
        platformTheme.name = lib.mkForce "qtct";
        style.name = "kvantum";
      };

      stylix = {
        enable = cfg.enable;
        targets = {
          neovim.enable = false;
          # kitty.enable = false;
          qt.platform = "qtct";
        };

        polarity = "dark";
        # base16Scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-dark-medium.yaml";

        image = cfg.wallpaper;
        cursor = cfg.cursor;
        fonts = {
          monospace = cfg.font;
          serif = config.stylix.fonts.monospace;
          sansSerif = config.stylix.fonts.monospace;
        };
        /*
           iconTheme = {
          enable = true;
          package = pkgs.papirus-icon-theme;
          dark = "Papirus Dark";
          light = "Papirus Light";
        };
        */
      };
    };
}
