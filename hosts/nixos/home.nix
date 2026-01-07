{
  pkgs,
  inputs,
  ...
}: {
  imports = [
    # TODO: Replace with a default.nix user module
    inputs.nix-flatpak.homeManagerModules.nix-flatpak
  ];

  config = {
    userSettings = {
      dotfiles = {
        enable = true;
        dotfilesDir = "/home/fabibo/.dotfiles";
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

    home.stateVersion = "24.11";

    nixpkgs.config.allowUnfree = true;

    # The home.packages option allows you to install Nix packages into your
    # environment
    home.packages = with pkgs; [
      # Nix management
      nh

      # CLI Tools
      git
      rustup
      zoxide
      fzf
      eza
      bat
      starship
      yazi
      delta
      codegrab
      xclip # Needed for codegrab

      # GUI Apps
      kitty
      google-chrome
      vesktop
      showtime
      qalculate-gtk
      zoom
      resources
      baobab
      neovide
      gnome-characters
      nautilus
      xournalpp
      qimgv

      # Fix for nvidia qt error
      (sioyek.overrideAttrs (old: {
        qtWrapperArgs = (old.qtWrapperArgs or []) ++ ["--set" "QT_QPA_PLATFORM" "xcb"];
      }))
    ];

    /*
       # Flatpaks
    services.flatpak.packages = [
      "com.github.ahrm.sioyek"
    ];
    */

    # Change desktop apps data
    xdg.desktopEntries = {
      kitty = {
        icon = "/home/fabibo/.config/kitty/kitty.app.png";
        name = "Kitty";
        exec = "kitty";
        comment = "Fast, feature-rich, GPU based terminal";
        categories = ["System" "TerminalEmulator"];
      };
    };

    # Nicely reload system units when changing configs
    systemd.user.startServices = "sd-switch";

    # Let Home Manager install and manage itself
    programs.home-manager.enable = true;
  };
}
