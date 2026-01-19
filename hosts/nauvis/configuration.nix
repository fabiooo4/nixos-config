{pkgs, ...}: {
  config = {
    theme = {
      active = "hyprland-caelestia";
    };

    systemSettings = {
      users = ["fabibo"];
      adminUsers = ["fabibo"];

      nvidia.enable = true;
      flatpak.enable = true;

      drawingTablet.enable = true;

      remaps = {
        keymap = [
          {
            name = "Super to Logitech G2 Key G8";
            remap = {
              "Ctrl_L-Shift_L-backslash" = "super_l";
            };
          }
        ];
      };
    };
  };
}
