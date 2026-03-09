{
  config,
  lib,
  ...
}: {
  options = {
    systemSettings = {
      rgb.enable = lib.mkEnableOption "rgb";
    };
  };

  config = let
    cfg = config.systemSettings;
  in
    lib.mkIf cfg.rgb.enable {
      services.hardware.openrgb.enable = true;
    };
}
