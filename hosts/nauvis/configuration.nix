{pkgs, ...}: {
  config = {
    theme = {
      active = "niri-noctalia";

      gnome-default = {
        stylix.wallpaper = pkgs.fetchurl {
          url = "https://raw.githubusercontent.com/fabiooo4/wallpapers/main/wallhaven-jxp6mq_1920x1080.png";
          hash = "sha256-Gle4Nk0V8qdt/91asPVjk5NQGQDRl7Y3e1WsnedT1XM=";
        };
      };
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
