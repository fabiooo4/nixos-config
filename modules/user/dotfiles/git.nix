{config, ...}: {
  home.file = {
    ".config/git" = {
      source = config.lib.file.mkOutOfStoreSymlink "${config.userSettings.dotfiles.dotfilesDir}/.config/git";
    };
  };
}
