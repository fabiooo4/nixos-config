{
  config,
  lib,
  ...
}: {
  options = {
    systemSettings = {
      joycons.enable = lib.mkEnableOption "joycond daemon for Nintendo Switch controllers";
    };
  };

  config = lib.mkIf config.systemSettings.joycons.enable {
    services.joycond.enable = true;
  };
}
