{
  config,
  lib,
  ...
}: {
  options = {
    systemSettings = {
      networking.wireless.enable = lib.mkEnableOption "wireless networking";
    };
  };

  config = let
    cfg = config.systemSettings;
  in {
    networking = {
      # Enable networking
      networkmanager.enable = true;

      wireless.enable = lib.mkIf cfg.networking.wireless.enable true;

      # Configure network proxy if necessary
      # proxy = {
      #    default = "http://user:password@proxy:port/";
      #    noProxy = "127.0.0.1,localhost,internal.domain";
      # };
    };
  };
}
