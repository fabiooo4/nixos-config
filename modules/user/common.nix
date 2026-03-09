{
  pkgs,
  lib,
  inputs,
  ...
}: {
  config = {
    # Suppress: 'You have set either `nixpkgs.config` or `nixpkgs.overlays` while using `home-manager.useGlobalPkgs`.'
    nixpkgs.config = lib.mkForce {};
    nixpkgs.overlays = lib.mkForce null;

    # Enable fonts from pkgs list
    fonts.fontconfig.enable = true;

    home.packages = with pkgs; [
      # Nix management
      nh
      nix-output-monitor

      xclip
      fastfetch
      resources
      showtime # Video viewer
      qimgv # Image viewer
      nautilus # File explorer
      baobab # Disk usage
      gnome-calendar
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
