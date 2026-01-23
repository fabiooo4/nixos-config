{
  pkgs,
  lib,
  config,
  ...
}:
lib.mkIf config.userSettings.dotfiles.kitty.enable {
  home.packages = [
    pkgs.kitty
  ];

  home.file = {
    ".config/kitty" = {
      source = config.lib.file.mkOutOfStoreSymlink "${config.userSettings.dotfiles.dotfilesDir}/.config/kitty";
    };
  };

  systemd.user.sessionVariables = {
    TERMINAL = "kitty";

    # TODO: termporary fix to glfw error on wayland
    KITTY_DISABLE_WAYLAND = 1;
  };

  # Change kitty image
  xdg.desktopEntries.kitty = {
    icon = "${config.userSettings.dotfiles.dotfilesDir}/.config/kitty/kitty.app.png";
    name = "Kitty";
    exec = "kitty";
    comment = "Fast, feature-rich, GPU based terminal";
    categories = ["System" "TerminalEmulator"];
  };
}
