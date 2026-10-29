{
  config,
  lib,
  pkgs,
  ...
}: {
  options = {
    systemSettings = {
      networking = {
        # wifi.enable = lib.mkEnableOption "wifi";
        bluetooth.enable = lib.mkEnableOption "bluetooth";
        tailscale.enable = lib.mkEnableOption "tailscale";
      };
    };
  };

  config = let
    cfg = config.systemSettings;
  in {
    networking = {
      # Enable networking
      networkmanager.enable = true;

      firewall = {
        allowedTCPPorts = [
          # remote-touchpad
          43877

          # minecraft
          # 25655
          # 24454

          # esp32 ota https server
          # 8070
        ];

        trustedInterfaces = lib.mkIf cfg.networking.tailscale.enable ["tailscale0"];
      };

      # wireless.enable = lib.mkIf cfg.networking.wifi.enable true;

      # Configure network proxy if necessary
      # proxy = {
      #    default = "http://user:password@proxy:port/";
      #    noProxy = "127.0.0.1,localhost,internal.domain";
      # };
    };

    hardware.bluetooth.enable = cfg.networking.bluetooth.enable;

    services.tailscale = lib.mkIf cfg.networking.tailscale.enable {
      enable = true;
      openFirewall = true;
      package = pkgs.unstable.tailscale;
      useRoutingFeatures = "client";
      extraSetFlags = lib.mkIf (cfg.adminUsers != []) [
        "--operator=${builtins.head cfg.adminUsers}"
      ];
    };
  };
}
