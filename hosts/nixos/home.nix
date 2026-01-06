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
    # TODO: Replace with a default.nix user module
    inputs.nix-flatpak.homeManagerModules.nix-flatpak
    ../../modules/user/stylix
    ../../modules/user/dotfiles
    ../../modules/user/gnome.nix
    ../../modules/user/spicetify.nix
    ../../modules/user/browser/zen/zen.nix
  ];

  config = {
    userSettings = {
      stylix.enable = true;
    };

    home.stateVersion = "24.11";

    nixpkgs.config.allowUnfree = true;

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
    ];

    # Flatpaks
    services.flatpak.packages = [
      "com.github.ahrm.sioyek"
    ];

    # Change desktop apps data
    xdg.desktopEntries = {
      kitty = {
        icon = "/home/" + userSettings.username + "/.config/kitty/kitty.app.png";
        name = "Kitty";
        exec = "kitty";
        comment = "Fast, feature-rich, GPU based terminal";
        categories = ["System" "TerminalEmulator"];
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

    # Nicely reload system units when changing configs
    systemd.user.startServices = "sd-switch";

    # Let Home Manager install and manage itself
    programs.home-manager.enable = true;
  };
}
