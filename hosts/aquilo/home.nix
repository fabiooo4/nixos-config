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
