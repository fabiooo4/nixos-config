{
  lib,
  pkgs,
  config,
  themeName,
  ...
}: {
  config = let
    enabled = config.theme.active == themeName;
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
