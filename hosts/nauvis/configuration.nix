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

      stylix = {
        enable = true;
        font = {
          name = "CaskaydiaCove Nerd Font";
          package = pkgs.nerd-fonts.caskaydia-cove;
        };
        cursor = {
          name = "XCursor-Pro-Dark";
          package = pkgs.xcursor-pro;
          size = 24;
        };
        wallpaper = pkgs.fetchurl {
          url = "https://raw.githubusercontent.com/fabiooo4/wallpapers/main/wallhaven-5w6w89.png";
          hash = "sha256-Z+CICFZSN64oIhhe66X7RlNn/gGCYAn30NLNoEHRYJY=";
        };
      };
    };
  };
}
