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
    };
}
