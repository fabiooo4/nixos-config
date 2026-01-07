{config, ...}: {
  home.file = {
    ".config/xournalpp" = {
      source = config.lib.file.mkOutOfStoreSymlink "${config.userSettings.dotfiles.dotfilesDir}/.config/xournalpp";
    };
  };
}
