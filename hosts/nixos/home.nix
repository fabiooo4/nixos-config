{
  pkgs,
  inputs,
  ...
}: {
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

    home.packages = with pkgs; [
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

      # GUI Apps
      kitty
      vesktop
      qalculate-gtk
      zoom
      gnome-characters
      xournalpp
    ];
  };
}
