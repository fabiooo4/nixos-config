{pkgs, ...}: {
  config = {
    environment.systemPackages = with pkgs; [
      custom-pkgs.mousedroid-server
    ];

    boot.kernelModules = ["uinput"];

    services.udev.packages = [
      pkgs.custom-pkgs.mousedroid-server
    ];

    networking.firewall = {
      allowedTCPPorts = [6969];
      allowedUDPPorts = [6969];
    };
  };
}
