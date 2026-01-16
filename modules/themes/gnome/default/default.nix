{
  lib,
  themeName,
  ...
}: {
  options.theme.${themeName} = {
    accentColor = lib.mkOption {
      type = lib.types.str;
      default = "orange";
      description = "Gnome accent color";
    };
  };
}
