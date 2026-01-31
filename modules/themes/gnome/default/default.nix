{
  lib,
  pkgs,
  config,
  themeName,
  ...
}: {
  options.theme.${themeName} = {
    accentColor = lib.mkOption {
      type = lib.types.str;
      default = "orange";
      description = "Gnome accent color";
    };

    stylix = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default =
          if config.theme.active == "gnome-default"
          then true
          else false;
        description = "Enable stylix theming";
      };

      wallpaper = lib.mkOption {
        description = "Wallpaper image.";
        type = lib.types.nullOr lib.types.path;
        default = pkgs.fetchurl {
          url = "https://raw.githubusercontent.com/fabiooo4/wallpapers/main/wallhaven-1k27r1_1920x1080.png";
          hash = "sha256-o8twOuiBBa57sAECpZDM6u6OnZ9CVgbi8horSbmy/5M=";
        };
        example = pkgs.fetchurl {
          url = "https://raw.githubusercontent.com/fabiooo4/wallpapers/main/wallhaven-1k27r1_1920x1080.png";
          hash = "sha256-o8twOuiBBa57sAECpZDM6u6OnZ9CVgbi8horSbmy/5M=";
        };
      };

      cursor = lib.mkOption {
        default = {
          name = "XCursor-Pro-Dark";
          package = pkgs.xcursor-pro;
          size = 24;
        };
        example = {
          name = "XCursor-Pro-Dark";
          package = pkgs.xcursor-pro;
          size = 24;
        };
        type = lib.types.nullOr (lib.types.submodule {
          options = {
            name = lib.mkOption {
              description = "Name of the cursor theme.";
              type = lib.types.str;
            };

            package = lib.mkOption {
              description = "Package providing the cursor theme.";
              type = lib.types.package;
            };

            size = lib.mkOption {
              description = "Cursor size.";
              type = lib.types.int;
              default = 24;
            };
          };
        });
      };

      font = lib.mkOption {
        default = {
          name = "CaskaydiaCove Nerd Font";
          package = pkgs.nerd-fonts.caskaydia-cove;
        };
        example = {
          name = "CaskaydiaCove Nerd Font";
          package = pkgs.nerd-fonts.caskaydia-cove;
        };
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
}
