{
  lib,
  pkgs,
  config,
  ...
}: {
  config = let
    enabled = config.theme.active == "gnome-default";
  in
    lib.mkIf enabled
    {
      # Enable the GNOME Desktop Environment.
      services.desktopManager.gnome.enable = true;
      services.displayManager.gdm.enable = true;

      # Remove gnome default apps
      services.gnome.core-apps.enable = false;
      environment = {
        gnome.excludePackages = with pkgs; [
          gnome-tour
        ];
        extraSetup = ''
          rm $out/share/applications/cups.desktop
        '';
      };
    };
}
