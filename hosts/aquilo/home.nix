{
  pkgs,
  config,
  ...
}: {
  config = {
    userSettings = {
      dotfiles = {
        enable = true;
        dotfilesDir = "${config.home.homeDirectory}/.dotfiles";
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
          url = "https://raw.githubusercontent.com/fabiooo4/wallpapers/main/wallhaven-1k27r1_1920x1080.png";
          hash = "sha256-o8twOuiBBa57sAECpZDM6u6OnZ9CVgbi8horSbmy/5M=";
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
      gemini-cli

      # GUI Apps
      kitty
      vesktop
      qalculate-gtk
      zoom-us
      gnome-characters
      xournalpp

      # Fonts
      monocraft
    ];
  };
}
