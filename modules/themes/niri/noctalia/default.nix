{
  lib,
  themeName,
  pkgs,
  ...
}: {
  options.theme.${themeName} = {
    interface = {
      scaling = lib.mkOption {
        type = lib.types.float;
        default = 1.;
        description = "Interface scaling percentage";
      };
    };

    bar = {
      density = lib.mkOption {
        type = lib.types.enum ["mini" "compact" "default" "comfortable" "spacious"];
        default = "default";
        description = "Bar density";
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
  };
}
