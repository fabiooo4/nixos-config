{pkgs, ...}: {
  config = {
    # Enable the GNOME Desktop Environment.
    services.displayManager.gdm.enable = true;
    services.desktopManager.gnome.enable = true;

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
