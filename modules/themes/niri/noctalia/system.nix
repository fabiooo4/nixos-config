{
  lib,
  config,
  themeName,
  ...
}: {
  config = let
    cfg = config.theme.${themeName};
    enabled = config.theme.active == themeName;
  in
    lib.mkIf enabled {
      services.displayManager.gdm = {
        enable = true;
        wayland = true;
      };

      programs.niri = {
        enable = true;
      };

      # Enable calendar events
      services.gnome.evolution-data-server.enable = true;
    };
}
