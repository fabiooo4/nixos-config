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

        kitty.enable = false;
      };
    };

    home.packages = with pkgs; [
      # CLI Tools
      zoxide
      fzf
      eza
      bat
      yazi
      delta
      codegrab
      gemini-cli

      # GUI Apps
      vesktop
      qalculate-gtk
      zoom-us
      gnome-characters

      # Fonts
      monocraft
    ];
  };
}
