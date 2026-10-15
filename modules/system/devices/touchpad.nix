{
  config,
  lib,
  ...
}: {
  options = {
    systemSettings = {
      touchpad = {
        enable = lib.mkEnableOption "touchpad";

        sensitivity = lib.mkOption {
          description = "Touchpad cursor speed factor. Must be between -1 and 1";
          type = lib.types.nullOr lib.types.str;
          default = null;
        };

        scrollFactor = lib.mkOption {
          description = "Touchpad scroll factor / speed multiplier. Values less than 1.0 decrease scroll sensitivity.";
          type = lib.types.nullOr lib.types.number;
          default = config.systemSettings.touchpad.scrollSensitivity;
        };

        scrollSensitivity = lib.mkOption {
          description = "Alias for scrollFactor.";
          type = lib.types.nullOr lib.types.number;
          default = null;
        };

        disableWhileTyping = lib.mkOption {
          description = "Disable touchpad while typing.";
          type = lib.types.bool;
          default = true;
        };

        clickMethod = lib.mkOption {
          description = "Touchpad click method. Permitted values: 'clickfinger' (two-finger right click, three-finger middle click) or 'button-areas'.";
          type = lib.types.enum ["clickfinger" "button-areas"];
          default = "clickfinger";
        };
      };
    };
  };

  config = let
    cfg = config.systemSettings.touchpad;
  in {
    services.libinput = lib.mkIf cfg.enable {
      enable = true;

      touchpad = {
        naturalScrolling = true;
        accelSpeed = cfg.sensitivity;
        disableWhileTyping = cfg.disableWhileTyping;
        tapping = true;
        clickMethod =
          if cfg.clickMethod == "button-areas"
          then "buttonareas"
          else cfg.clickMethod;
      };
    };
  };
}
