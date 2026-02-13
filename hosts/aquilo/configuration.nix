{pkgs, ...}: {
  config = {
    theme = {
      active = "niri-noctalia";
    };

    systemSettings = {
      users = ["fabibo"];
      adminUsers = ["fabibo"];

      flatpak.enable = true;
      touchpad.enable = true;

      drawingTablet.enable = true;
    };

    # Enable battery management
    services.upower.enable = true;
  };
}
