{
  lib,
  config,
  options,
  pkgs,
  inputs,
  ...
}: {
  options = {
    systemSettings.stylix = {
      enable = lib.mkEnableOption "Enable stylix theming";
      wallpaper = options.stylix.image;
      cursor = options.stylix.cursor;

      /*
         wallpaper = lib.mkOption {
        description = "Wallpaper image";
        type = lib.types.nullOr (lib.types.path);
        default = null;
      };
      */

      /*
         cursor = lib.mkOption {
        description = "Cursor definition";
        default = null;
        type = lib.types.nullOr (lib.types.submodule {
          options = {
            name = lib.mkOption {
              description = "The cursor name within the package.";
              type = lib.types.nullOr (lib.types.str);
              default = null;
            };
            package = lib.mkOption {
              description = "Package providing the cursor theme.";
              type = lib.types.nullOr (lib.types.package);
              default = null;
            };
            size = lib.mkOption {
              description = "The cursor size.";
              type = lib.types.nullOr (lib.types.int);
              default = null;
            };
          };
        });
      };
      */

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

  imports = [inputs.stylix.nixosModules.stylix];

  config = let
    cfg = config.systemSettings.stylix;
  in
    lib.mkIf cfg.enable {
      stylix = {
        enable = true;
        targets.chromium.enable = false;

        polarity = "dark";
        base16Scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-dark-medium.yaml";

        image = cfg.wallpaper;
        cursor = cfg.cursor;
        fonts = {
          monospace = cfg.font;
          serif = config.stylix.fonts.monospace;
          sansSerif = config.stylix.fonts.monospace;
        };
      };
    };
}
