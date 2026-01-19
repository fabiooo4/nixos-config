{
  pkgs,
  inputs,
  ...
}: {
  imports = [
    inputs.nix-flatpak.homeManagerModules.nix-flatpak
  ];

  config = {
    # Enable fonts from pkgs list
    fonts.fontconfig.enable = true;

    home.packages = with pkgs; [
      # Nix management
      nh

      xclip
      resources
      showtime # Video viewer
      qimgv # Image viewer
      nautilus # File explorer
      neovide # Text editor
      baobab # Disk usage
    ];

    # Flatpaks
    services.flatpak.packages = [
      "com.github.ahrm.sioyek" # pdf viewer
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
          "application/pdf" = "com.github.ahrm.sioyek.desktop";
          "text/plain" = "neovide.desktop";
        };
      };
    };
  };
}
