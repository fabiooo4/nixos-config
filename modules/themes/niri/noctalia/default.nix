{
  lib,
  themeName,
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
        type = lib.types.enum [ "mini" "compact" "default" "comfortable" "spacious" ];
        default = "default";
        description = "Bar density";
      };
    };
  };
}
