{...}: {
  config = {
    theme = {
      active = "hyprland-caelestia";
      hyprland-caelestia = {
        monitorScale = "0.75";
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
