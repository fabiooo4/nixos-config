{config, ...}: {
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
}
