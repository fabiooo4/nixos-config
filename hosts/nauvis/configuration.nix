{pkgs, ...}: {
  config = {
    theme = {
      active = "niri-noctalia";

      gnome-default = {
        stylix.wallpaper = pkgs.fetchurl {
          url = "https://raw.githubusercontent.com/fabiooo4/wallpapers/main/wallhaven-96evzk_1920x1080.png";
          hash = "sha256-ZRcjR2t2r1RoykaslIJ3RjoxepSY9b8jZLH59b1raqw=";
        };
      };
    };

    systemSettings = {
      users = ["fabibo"];
      adminUsers = ["fabibo"];

      nvidia.enable = true;
      flatpak.enable = true;

      drawingTablet.enable = true;
      /*
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
      */
    };
  };
}
