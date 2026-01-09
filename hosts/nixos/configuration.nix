{pkgs, ...}: {
  config = {
    systemSettings = {
      users = ["fabibo"];
      adminUsers = ["fabibo"];

      nvidia.enable = true;
      flatpak.enable = true;

      remaps = {
        keymap = [
          {
            remap = {"C-l" = "esc";};
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

    # Enable the GNOME Desktop Environment.
    services.displayManager.gdm.enable = true;
    services.desktopManager.gnome.enable = true;

    # Remove gnome default apps
    services.gnome.core-apps.enable = false;
    environment = {
      gnome.excludePackages = with pkgs; [
        gnome-tour
      ];
      extraSetup = ''
        rm $out/share/applications/cups.desktop
      '';
    };
  };
}
