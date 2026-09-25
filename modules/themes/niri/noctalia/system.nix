{
  lib,
  inputs,
  pkgs,
  config,
  themeName,
  ...
}: {
  imports = [
    inputs.noctalia-greeter.nixosModules.default
  ];

  config = let
    cfg = config.theme.${themeName};
    enabled = config.theme.active == themeName;
  in
    lib.mkIf enabled {
      services.displayManager.noctalia-greeter = {
        enable = true;

        passwordless-sync-users = ["fabibo"];

        cursorTheme.package = cfg.cursor.package;

        settings = {
          cursor = {
            theme = cfg.cursor.name;
            size = cfg.cursor.size;
          };
          keyboard = {
            layout = "us";
            variant = "intl";
          };
        };
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
