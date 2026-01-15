{
  config,
  lib,
  ...
}: {
  options = {
    systemSettings = {
      touchpad = {
        enable = lib.mkEnableOption "touchpad";

        scrollDelta = lib.mkOption {
          description = "How slow to make the touchpad scroll";
          type = lib.types.int;
          default = 100;
        };

        sensitivity = lib.mkOption {
          description = "Touchpad cursor speed factor. Must be between 0 and 1";
          type = lib.types.str;
          default = "0.6";
        };

        acceleration = lib.mkOption {
          description = "Wether to enable touchpad acceleration";
          type = lib.types.bool;
          default = true;
        };
      };
    };
  };

  config = let
    cfg = config.systemSettings;
  in {
    # Enable touchpad support (enabled default in most desktopManager).
    services.xserver.libinput.enable = lib.mkIf cfg.touchpad.enable false;
    services.xserver.synaptics = lib.mkIf cfg.touchpad.enable {
      enable = true;
      twoFingerScroll = true;

      scrollDelta = cfg.touchpad.scrollDelta;
      minSpeed = cfg.touchpad.sensitivity;
      accelFactor =
        if cfg.touchpad.acceleration
        then "0.001"
        else "0";
    };
  };
}
