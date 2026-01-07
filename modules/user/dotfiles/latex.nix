{config, ...}: {
  # Latexmkrc
  home.file = {
    ".latexmkrc" = {
      source = config.lib.file.mkOutOfStoreSymlink "${config.userSettings.dotfiles.dotfilesDir}/.latexmkrc";
    };
  };
}
