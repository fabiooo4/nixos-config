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

      boot.plymouth = {
        enable = true;
        theme = "connect";
        themePackages = with pkgs; [
          adi1090x-plymouth-themes
        ];
      };

      programs.niri = {
        enable = true;
        package = pkgs.unstable.niri;
      };

      # Enable gtk file pickers
      programs.dconf.enable = true;
      environment.variables = {
        GSETTINGS_SCHEMA_DIR = "${pkgs.gtk3}/share/gsettings-schemas/${pkgs.gtk3.name}/glib-2.0/schemas";
      };

      # Enable calendar events
      services.gnome.evolution-data-server.enable = true;

      # Calendar accounts setup
      services.gnome.gnome-online-accounts.enable = true;
      services.gnome.gnome-keyring.enable = true;
    };
}
