{...}: {
  config = {
    theme = {
      active = "niri-noctalia";

      niri-noctalia = {
        bar.percent = 0.575;
        idle.enable = true;
      };
    };

    systemSettings = {
      users = ["fabibo"];
      adminUsers = ["fabibo"];

      flatpak.enable = true;
      touchpad = {
        enable = true;
        scrollFactor = 0.5;
      };

      drawingTablet.enable = true;
      joycons.enable = true;

      networking = {
        bluetooth.enable = true;
      };

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
    services.power-profiles-daemon.enable = true;
  };
}
