{
  lib,
  themeName,
  ...
}: {
  options.theme.${themeName} = {
    interface = {
      scaling = lib.mkOption {
        type = lib.types.float;
        default = 1.00;
        description = "Interface scaling percentage";
      };
    };
  };
}
