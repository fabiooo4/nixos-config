{
  config,
  userSettings,
  ...
}: {
  home.file = {
    ".config/git" = {
      source = config.lib.file.mkOutOfStoreSymlink "${userSettings.dotfilesDir}/.config/git";
    };
  };
}
