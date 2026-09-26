{
  lib,
  themeName,
  pkgs,
  ...
}: {
  options.theme.${themeName} = {
    bar = {
      percent = lib.mkOption {
        type = lib.types.float;
        default = 0.4;
        description = "Bar length as a percentage";
      };
    };

    idle.enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable automatic lock and suspend";
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
  };
}
