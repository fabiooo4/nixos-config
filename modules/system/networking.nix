{
  config,
  lib,
  ...
}: {
  options = {
    systemSettings = {
      networking = {
        # wifi.enable = lib.mkEnableOption "wifi";
        bluetooth.enable = lib.mkEnableOption "bluetooth";
      };
    };
  };

  config = let
    cfg = config.systemSettings;
  in {
    networking = {
      # Enable networking
      networkmanager.enable = true;

      # remote-touchpad
      firewall.allowedTCPPorts = [43877];

      # wireless.enable = lib.mkIf cfg.networking.wifi.enable true;

      # Configure network proxy if necessary
      # proxy = {
      #    default = "http://user:password@proxy:port/";
      #    noProxy = "127.0.0.1,localhost,internal.domain";
      # };
    };

    hardware.bluetooth.enable = cfg.networking.bluetooth.enable;
  };
}
