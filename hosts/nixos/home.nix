{
  config,
  pkgs,
  inputs,
  userSettings,
  ...
}: let
  rebuild-script = import ../../scripts/rebuild.nix {
    inherit pkgs;
    nixosDirectory = userSettings.nixosConfigDir;
  };
in {
  imports = [
    inputs.nix-flatpak.homeManagerModules.nix-flatpak
    inputs.zen-browser.homeModules.beta
    ../../modules/home-manager/dotfiles
    ../../modules/home-manager/gnome.nix
    ../../modules/home-manager/spicetify.nix
  ];
  nixpkgs.config.allowUnfree = true;

  home.username = userSettings.username;
  home.homeDirectory = "/home/" + userSettings.username;

  home.stateVersion = "24.11"; # Don't change

  # The home.packages option allows you to install Nix packages into your
  # environment
  home.packages = with pkgs; [
    # Nix management
    nh
    rebuild-script

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
  ];

  programs.zen-browser = {
    enable = true;
    profiles = {
      ${userSettings.username} = {};
    };
  };

  systemd.user.sessionVariables = {
    EDITOR = userSettings.editor;
    BROWSER = userSettings.browser;
    TERMINAL = userSettings.term;
    FLAKE = userSettings.nixosConfigDir;
    NH_FLAKE = userSettings.nixosConfigDir;

    # TODO: termporary fix to glfw error on wayland
    KITTY_DISABLE_WAYLAND = 1;
  };

  # Flatpaks
  services.flatpak.packages = [
    "com.github.ahrm.sioyek"
  ];

  # Style
  stylix = {
    enable = true;
    targets.neovim.enable = false;
    targets.kitty.enable = false;
    targets.zen-browser.profileNames = [userSettings.username];

    polarity = "dark";
    base16Scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-dark-medium.yaml";

    image = userSettings.wallpaper;
    cursor = {
      package = userSettings.cursorPkg;
      name = userSettings.cursor;
      size = 24;
    };
    fonts = {
      monospace = {
        package = userSettings.fontPkg;
        name = userSettings.font;
      };
      serif = config.stylix.fonts.monospace;
      sansSerif = config.stylix.fonts.monospace;
    };
    iconTheme = {
      enable = true;
      package = pkgs.papirus-icon-theme;
      dark = "Papirus Dark";
      light = "Papirus Light";
    };
  };

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # Let Home Manager install and manage itself
  programs.home-manager.enable = true;
}
