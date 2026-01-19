{pkgs, ...}: {
  config = {
    systemSettings = {
      users = ["fabibo"];
      adminUsers = ["fabibo"];

      flatpak.enable = true;
      touchpad.enable = true;

      drawingTablet.enable = true;
    };
  };
}
