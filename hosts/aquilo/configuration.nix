{pkgs, ...}: {
  config = {
    theme = {
      gnome-default = {
        stylix.wallpaper = pkgs.fetchurl {
          url = "https://raw.githubusercontent.com/fabiooo4/wallpapers/main/wallhaven-gw55w7_1920x1080.png";
          hash = "sha256-UOryQneCfMJVH2QXmxI5exSGttemy94qO2zU879viaY=";
        };
      };
    };

    systemSettings = {
      users = ["fabibo"];
      adminUsers = ["fabibo"];

      flatpak.enable = true;
      touchpad.enable = true;

      drawingTablet.enable = true;
    };
  };
}
