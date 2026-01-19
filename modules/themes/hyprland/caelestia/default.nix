{
  lib,
  themeName,
  ...
}: {
  options.theme.${themeName} = {
    monitorScale = lib.mkOption {
      type = lib.types.str;
      default = "1";
      example = "1.5";
      description = "Scale factor for the monitor in Caelestia Shell.";
    };
  };
}
