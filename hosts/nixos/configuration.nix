{pkgs, ...}: {
  config = {
    systemSettings = {
      users = ["fabibo"];
      adminUsers = ["fabibo"];

      nvidia.enable = true;
      flatpak.enable = true;

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

    # Configure keymap in X11
    services.xserver.xkb = {
      layout = "us";
      variant = "intl";
    };

    # Configure remaps
    services.xremap = {
      enable = true;
      withGnome = true;
      mouse = true;
      config = {
        keymap = [
          {
            name = "Capslock to Esc";
            remap = {
              "capslock" = "esc";
            };
          }
          {
            name = "Super to Logitech G2 Key G8";
            remap = {
              "Ctrl_L-Shift_L-backslash" = "super_l";
            };
          }
        ];
      };
    };

    # Configure console keymap
    console.keyMap = "us-acentos";

    # Enable touchpad support (enabled default in most desktopManager).
    # services.xserver.libinput.enable = true;
  };
}
