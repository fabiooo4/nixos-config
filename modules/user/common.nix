{
  pkgs,
  lib,
  inputs,
  ...
}: {
  config = {
    # Enable fonts from pkgs list
    fonts.fontconfig.enable = true;

    home.packages = with pkgs; [
      # Nix management
      nh
      nix-output-monitor

      # CLI Tools
      zoxide
      fzf
      fd
      ripgrep
      eza
      bat
      yazi
      delta
      codegrab
      gemini-cli
      xclip
      fastfetch

      # GUI Apps
      qalculate-gtk
      gnome-characters
      resources
      showtime # Video viewer
      qimgv # Image viewer
      nautilus # File explorer
      baobab # Disk usage
      gnome-calendar
      gparted # Partition manager
    ];

    home.stateVersion = "24.11";

    # Nicely reload system units when changing configs
    systemd.user.startServices = "sd-switch";

    # Let Home Manager install and manage itself
    programs.home-manager.enable = true;

    xdg = {
      # Set default apps for xdg-open
      mimeApps = {
        enable = true;
        defaultApplications = {
          "image/png" = "qimgv.desktop";
          "image/jpeg" = "qimgv.desktop";
          "application/pdf" = "sioyek.desktop";
          "text/plain" = "nvim.desktop";
        };
      };
    };
  };
}
