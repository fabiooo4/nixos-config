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

      remaps = {
        modmap = [
          {
            name = "Menu to Super";
            remap = {
              "compose" = "super_l";
            };
          }
        ];
      };
    };

    # Enable battery management
    services.upower.enable = true;
  };
}
