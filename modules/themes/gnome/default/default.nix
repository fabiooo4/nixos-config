{
  lib,
  ...
}: {
  options.theme.gnome-default = {
    accentColor = lib.mkOption {
      type = lib.types.str;
      default = "orange";
      description = "Gnome accent color";
    };
  };
}
