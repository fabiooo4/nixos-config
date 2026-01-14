{
  config,
  lib,
  ...
}: {
  options = {
    systemSettings = {
      drawingTablet.enable = lib.mkEnableOption "drawing tablet";
    };
  };

  config = let
    cfg = config.systemSettings;
  in
    lib.mkIf cfg.drawingTablet.enable {
      # Drawing tablet driver
      services.xserver.wacom.enable = false;
      hardware.opentabletdriver = {
        enable = true;
        daemon.enable = true;
      };

      # This runs at boot and ensures the default config file exists and is writable.
      systemd.tmpfiles.rules = let
        # Helper function to generate rules for a specific user
        mkUserRules = user: [
          # Ensure the directory exists, set permissions owner (user), group (users)
          "d /home/${user}/.config/OpenTabletDriver 0755 ${user} users - -"

          # Copy settings to user config if it doesn't exist
          "C /home/${user}/.config/OpenTabletDriver/settings.json 0644 ${user} users - ${./settings.json}"
        ];
      in
        # Apply these rules for every user defined in systemSettings
        lib.concatMap mkUserRules config.systemSettings.users;
    };
}
