{
  lib,
  pkgs,
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
        # TODO: Remove when the blur pull request gets merged
        # https://github.com/niri-wm/niri/pull/3483
        package = pkgs.unstable.niri-blur;
      };

      # Enable calendar events
      services.gnome.evolution-data-server.enable = true;

      # Calendar accounts setup
      services.gnome.gnome-online-accounts.enable = true;
      services.gnome.gnome-keyring.enable = true;
    };
}
