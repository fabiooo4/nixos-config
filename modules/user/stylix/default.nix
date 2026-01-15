{
  config,
  options,
  lib,
  pkgs,
  inputs,
  osConfig,
  ...
}: {
  options = {
    userSettings.stylix = {
      enable = lib.mkEnableOption "Enable stylix theming";
      wallpaper = options.stylix.image;
      cursor = options.stylix.cursor;

      font = lib.mkOption {
        default = null;
        type = lib.types.nullOr (lib.types.submodule {
          options = {
            name = lib.mkOption {
              description = "Name of the font.";
              type = lib.types.str;
            };

            package = lib.mkOption {
              description = "Package providing the font.";
              type = lib.types.package;
            };
          };
        });
      };
    };
  };

  # Cannot import home manager module if system module has already been imported
  imports = lib.optionals (!osConfig.stylix.enable) [inputs.stylix.homeModules.stylix];

  config = let
    cfg = config.userSettings.stylix;
  in
    lib.mkIf cfg.enable {
      qt = {
        enable = true;
        platformTheme.name = lib.mkForce "qtct";
        style.name = "kvantum";
      };

      stylix = {
        enable = config.userSettings.stylix.enable;
        targets = {
          neovim.enable = false;
          kitty.enable = false;
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
