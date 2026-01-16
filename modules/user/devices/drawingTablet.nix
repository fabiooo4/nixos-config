{
  config,
  lib,
  osConfig,
  ...
}: let
  defaultSettings = {
    Revision = "0.6.6.2";
    Profiles = [
      {
        Tablet = "Wacom CTL-472";
        OutputMode = {
          Path = "OpenTabletDriver.Desktop.Output.AbsoluteMode";
          Settings = [];
          Enable = true;
        };
        Filters = [];
        AbsoluteModeSettings = {
          Display = {
            Width = 1920.0;
            Height = 1080.0;
            X = 960.0;
            Y = 540.0;
            Rotation = 0.0;
          };
          Tablet = {
            Width = 152.0;
            Height = 95.0;
            X = 76.0;
            Y = 47.5;
            Rotation = 0.0;
          };
          EnableClipping = true;
          EnableAreaLimiting = false;
          LockAspectRatio = false;
        };
        RelativeModeSettings = {
          XSensitivity = 10.0;
          YSensitivity = 10.0;
          RelativeRotation = 0.0;
          RelativeResetDelay = "00:00:00.1000000";
        };
        Bindings = {
          TipActivationThreshold = 1.0;
          TipButton = {
            Path = "OpenTabletDriver.Desktop.Binding.AdaptiveBinding";
            Settings = [
              {
                Property = "Binding";
                Value = "Tip";
              }
            ];
            Enable = true;
          };
          EraserActivationThreshold = 1.0;
          EraserButton = {
            Path = "OpenTabletDriver.Desktop.Binding.AdaptiveBinding";
            Settings = [
              {
                Property = "Binding";
                Value = "Eraser";
              }
            ];
            Enable = true;
          };
          PenButtons = [null null];
          AuxButtons = [];
          MouseButtons = [];
          MouseScrollUp = null;
          MouseScrollDown = null;
          DisablePressure = false;
          DisableTilt = false;
        };
      }
    ];
    LockUsableAreaDisplay = true;
    LockUsableAreaTablet = true;
    Tools = [];
  };

  # Serialize the Nix set to a JSON string
  settingsJson = builtins.toJSON defaultSettings;
in
  lib.mkIf osConfig.systemSettings.drawingTablet.enable {
    # Write the default configuration if it doesn't exist
    home.activation.configureOpenTabletDriver = lib.hm.dag.entryAfter ["writeBoundary"] ''
      verboseEcho "Configuring OpenTabletDriver settings..."

      CONFIG_DIR="${config.home.homeDirectory}/.config/OpenTabletDriver"
      SETTINGS_FILE="$CONFIG_DIR/settings.json"

      if [ ! -d "$CONFIG_DIR" ]; then
        mkdir -p "$CONFIG_DIR"
      fi

      # Overwrite the settings file with the one defined in Nix
      # Use 'cat' to write a standard mutable file rather than a symlink
      echo '${settingsJson}' > "$SETTINGS_FILE"

      # Ensure proper permissions
      chmod 644 "$SETTINGS_FILE"
    '';
  }
