{config, ...}: {
  # Sioyek
  home.file = {
    ".config/sioyek" = {
      source = config.lib.file.mkOutOfStoreSymlink "${config.userSettings.dotfiles.dotfilesDir}/.config/sioyek";
    };
  };
}
