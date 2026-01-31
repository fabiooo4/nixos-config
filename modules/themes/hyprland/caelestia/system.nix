{
  pkgs,
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
      programs.hyprland = {
        enable = true;
        xwayland.enable = true;
      };

      # Login screen
      services.displayManager.gdm = {
        enable = true;
        wayland = true;
      };

      # Session password handler
      services.gnome.gnome-keyring.enable = true;
      security.pam.services.sddm.enableGnomeKeyring = true;

      # Screen sharing, file opening windows gui
      xdg.portal = {
        enable = true;
        extraPortals = [pkgs.xdg-desktop-portal-hyprland];
        config.common.default = "*";
      };

      # Gui sudo password popup
      security.polkit.enable = true;
    };
}
